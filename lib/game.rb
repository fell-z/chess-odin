require "yaml"
require_relative "./chess_pieces"
require_relative "./board"
require_relative "./player"
require_relative "./saveable"

# This class manages the game loop, calling the methods and resolving the outcomes of it,
# proceding it until the game is over.
class Game
  include Saveable

  SUCCESS = true
  FAILURE = false

  def initialize
    @board = Board.new
    @player_white = Player.new(@board, :white)
    @player_black = Player.new(@board, :black)

    @player_order = [@player_white, @player_black]

    welcome_message
    place_all_pieces
    gets.chomp

    load_save(select_save) if load_save?
  end

  def start
    loop do
      current_player = @player_order.first

      @board.render

      if current_player.king.check?
        return announce_game_end(@player_order[1]) if current_player.king.checkmate?

        announce_check(current_player)
      end

      puts "< #{current_player.side}'s turn >"

      result = start_player_turn(current_player)

      break save_game if result == :save

      next if result == FAILURE

      @player_order.rotate!
    end
  end

  # rubocop:disable Metrics
  def start_player_turn(player)
    play = player_input(player)

    return play if play == :save

    return player.king.castling(play[:castling_type]) if play[:castling?]

    piece = select_piece(player, play)

    case play[:type]
    when :move
      result = check_after_move?(player, piece, play[:dest_pos])
      piece.move(play[:dest_pos]) unless result
      check_error_message if result
    when :capture
      result = check_after_capture?(player, piece, play[:dest_pos])
      piece.capture(play[:dest_pos]) unless result
      check_error_message if result
    end

    return FAILURE if result

    piece.promote(play[:promotion_piece]) if play[:promotion_piece]

    SUCCESS
  end
  # rubocop:enable Metrics

  private

  def check_after_move?(player, piece, dest_pos)
    @board.move_piece(piece.position, dest_pos)
    result = player.king.check?
    @board.move_piece(dest_pos, piece.position)

    result
  end

  def check_after_capture?(player, piece, dest_pos)
    captured_piece = @board.at_position(dest_pos)

    @board.move_piece(piece.position, dest_pos)
    result = player.king.check?
    @board.move_piece(dest_pos, piece.position)
    @board.place_piece_at(dest_pos, captured_piece)

    result
  end

  # rubocop:disable Metrics
  def player_input(player)
    loop do
      play = player.play_input

      return play if play == :save

      next input_error_message if play == FAILURE

      if play[:castling?]
        next castling_error_message unless player.king.castling?(play[:castling_type])

        break play
      end

      total_of_pieces = select_by_dest_pos(player.pieces { |piece| piece.is_a?(play[:piece]) }, play).size

      next invalid_play_error_message if total_of_pieces.zero?

      next origin_error_message if total_of_pieces > 1 && play[:origin].nil?

      if play[:promotion_piece]
        next promote_error_message unless [0, 7].include?(play[:dest_pos][0])
      elsif play[:piece] == Pawn && [0, 7].include?(play[:dest_pos][0])
        next no_promote_piece_error_message
      end

      sleep(0.4)

      break play
    end
  end
  # rubocop:enable Metrics

  def select_by_dest_pos(pieces, play)
    pieces.select do |piece|
      if play[:type] == :move
        piece.possible_moves.include?(play[:dest_pos])
      elsif play[:type] == :capture
        piece.possible_captures.include?(play[:dest_pos])
      end
    end
  end

  def select_by_origin(pieces, play)
    selected_by_rank = pieces.select { |piece| piece.position[0] == play[:origin] }
    selected_by_file = pieces.select { |piece| piece.position[1] == play[:origin] }

    return selected_by_rank if selected_by_rank.size == 1

    selected_by_file if selected_by_file.size == 1
  end

  def select_piece(player, play)
    pieces = player.pieces { |piece| piece.is_a?(play[:piece]) }
    pieces = select_by_dest_pos(pieces, play)

    return select_by_origin(pieces, play)[0] if pieces.size > 1

    pieces[0]
  end

  def input_error_message
    puts "Oops! It looks like you've entered some invalid input.\nTry again!"
  end

  def invalid_play_error_message
    puts "So... There's no piece who can do that play.\nTry again!"
  end

  def castling_error_message
    puts "Hey! You tried to perform a invalid castling.\nTry again!"
  end

  def promote_error_message
    puts "Hm... Maybe isn't the right time to do a promotion.\nTry again!"
  end

  def no_promote_piece_error_message
    puts "Although you moved a pawn to the last rank, you didn't include a piece to promote to!\nTry again!"
  end

  def origin_error_message
    puts "There's more than one piece with the same move or capture.\nTry again specifying the origin(rank or file)!"
  end

  def check_error_message
    puts "Stop! That play puts your king in check.\nTry another play!"
  end

  def announce_game_end(winning_player)
    side = winning_player.side.to_s.capitalize
    puts "#{side} checkmates the other player. #{side} wins the game!"
  end

  def announce_check(player_in_check)
    puts <<~CHECK
      The #{player_in_check.side}'s king is in check!
      Capture the piece leaving the king in check or move a piece to remove the check."
    CHECK
  end

  def welcome_message
    puts <<~WELCOME
      This is a regular game of chess, same rules and all that.

      This game use as inputs the algebraic notation, the standard one.
      i.e.  Nf4 (this input moves a knight to the f4 square)
            Qxc4 (this input use a queen to capture a piece at c4)
      Here you can learn how to use it: https://en.wikipedia.org/wiki/Algebraic_notation_(chess)

      P.S.: castling inputs are 0-0 or 0-0-0 (kingside and queenside).
            promotion inputs follows the pattern: 'xy=Z'
                whereas 'xy' stands for the usual input and Z stands for the piece wanted to promote to.

      The game starts with the white pieces.
      You can save whenever you want by typing 'save'.

      Press Enter to continue.
    WELCOME
  end

  def place_all_pieces
    pieces_to_place = YAML.unsafe_load(File.read("./lib/pieces_to_place.yaml"))

    pieces_to_place.each do |piece, params|
      params.each do |param|
        piece.new(@board, param[:side], param[:pos])
      end
    end
  end
end

require_relative "./input_parser"

# Implementation of a player, with methods to ask for a input(be a move or some decision) and etc.
class Player
  attr_reader :side

  def initialize(board, side)
    @board = board
    @side = side
  end

  def input
    gets.chomp
  end

  def play_input
    player_input = input

    parsed_castling = InputParser.parse_castling(player_input)
    return { piece: King }.merge(parsed_castling) if parsed_castling[:castling?]

    play = InputParser.parse_all_data(player_input)
    return :failure if play == :failure

    indexes = InputParser.parse_all_indexes(player_input)
    return :failure unless indexes == indexes.sort

    play
  end

  def pieces(&filter)
    all_pieces = @board.all_pieces_of(@side)

    return all_pieces unless block_given?

    all_pieces.select(&filter)
  end
end

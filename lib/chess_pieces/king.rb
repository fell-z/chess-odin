require_relative "./modules/piece_base"
require_relative "./modules/special_movement"

# Implementation of chess king
class King
  include PieceBase
  include SpecialMovement

  def initialize(board, side, position)
    super

    @first_move = true
  end

  def castling?(side)
    king_rank = @position[0]
    rook_file = side == :kingside ? 7 : 0
    rook = @board.at_position([king_rank, rook_file])

    verifying_squares =
      { kingside: [[king_rank, 5], [king_rank, 6]],
        queenside: [[king_rank, 3], [king_rank, 2], [king_rank, 1]] }[side]

    return false unless rook.is_a?(Rook) && (@first_move && rook.first_move)
    return false unless @board.empty_at?(verifying_squares)

    true
  end

  # rubocop:disable Metrics/MethodLength
  def castling(side)
    return FAILURE unless castling?(side)

    king_rank = @position[0]
    rook_file = side == :kingside ? 7 : 0
    rook = @board.at_position([king_rank, rook_file])

    new_positions =
      { kingside: { king: [king_rank, 6], rook: [king_rank, 5] },
        queenside: { king: [king_rank, 2], rook: [king_rank, 3] } }[side]

    rook.move(new_positions[:rook])
    @board.move_piece(@position, new_positions[:king])
    @position = new_positions[:king]
    @first_move = false

    SUCCESS
  end
  # rubocop:enable Metrics/MethodLength

  def check?
    opponent_pieces = @board.all_pieces_of(@side == :white ? :black : :white)
    opponent_pieces.any? { |piece| piece.possible_captures.include?(@position) }
  end

  def checkmate?
    ally_pieces = @board.all_pieces_of(@side).reject { |piece| piece.is_a?(King) }

    save_trys = []

    save_trys.concat(save_by_moving(self), save_by_capturing(self))

    ally_pieces.each do |ally_piece|
      save_trys.concat(save_by_moving(ally_piece, @position), save_by_capturing(ally_piece, @position))
    end

    save_trys.all?
  end

  def move(dest_pos)
    exit_code = super

    @first_move = false if exit_code == SUCCESS && @first_move

    exit_code
  end

  def capture(piece_pos)
    exit_code = super

    @first_move = false if exit_code == SUCCESS && @first_move

    exit_code
  end

  def to_s
    "♚"
  end

  private

  def directions
    DIRECTIONS
  end

  # The following method is a bit specific in its objective, the name don't exactly translate
  # what it is doing.
  # They try all possible moves of the specified piece and check if any of the opponent pieces
  # have(or still have) the capture position of the king's square(if provided) or the move position
  # itself(in case the specified piece is the king).
  def save_by_moving(piece, king_square = nil)
    save_trys = []

    piece.possible_moves.each do |move_pos|
      @board.move_piece(piece.position, move_pos)
      opponent_pieces = @board.all_pieces_of(@side == :white ? :black : :white)
      save_trys <<
        opponent_pieces.any? { |opponent_piece| opponent_piece.possible_captures.include?(king_square || move_pos) }
      @board.move_piece(move_pos, piece.position)
    end

    save_trys.uniq
  end

  # The following method is a bit specific in its objective, the name don't exactly translate
  # what it is doing.
  # They try all possible captures of the specified piece and check if any of the opponent pieces
  # have(or still have) the capture position of the king's square(if provided) or the capture position
  # itself(in case the specified piece is the king).
  def save_by_capturing(piece, king_square = nil)
    save_trys = []

    piece.possible_captures.each do |capture_pos|
      captured_piece = @board.at_position(capture_pos)
      @board.move_piece(piece.position, capture_pos)
      opponent_pieces = @board.all_pieces_of(@side == :white ? :black : :white)
      save_trys <<
        opponent_pieces.any? { |opponent_piece| opponent_piece.possible_captures.include?(king_square || capture_pos) }
      @board.move_piece(capture_pos, piece.position)
      @board.place_piece_at(capture_pos, captured_piece)
    end

    save_trys.uniq
  end
end

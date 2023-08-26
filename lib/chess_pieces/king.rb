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

  # rubocop:disable Metrics/MethodLength
  def castling(side)
    king_rank = @position[0]
    rook_file = side == :kingside ? 7 : 0
    rook = @board.at_position([king_rank, rook_file])

    verifying_squares =
      { kingside: [[king_rank, 5], [king_rank, 6]],
        queenside: [[king_rank, 3], [king_rank, 2], [king_rank, 1]] }[side]

    return :failure unless rook.is_a?(Rook) && (@first_move && rook.first_move)
    return :failure unless @board.empty_at?(verifying_squares)

    new_positions =
      { kingside: { king: [king_rank, 6], rook: [king_rank, 5] },
        queenside: { king: [king_rank, 2], rook: [king_rank, 3] } }[side]

    rook.move(new_positions[:rook])
    @board.move_piece(@position, new_positions[:king])
    @position = new_positions[:king]
    @first_move = false

    :success
  end
  # rubocop:enable Metrics/MethodLength

  def move(dest_pos)
    exit_code = super

    @first_move = false if exit_code == :success && @first_move

    exit_code
  end

  def capture(piece_pos)
    exit_code = super

    @first_move = false if exit_code == :success && @first_move

    exit_code
  end

  def to_s
    "♚"
  end

  private

  def directions
    DIRECTIONS
  end
end

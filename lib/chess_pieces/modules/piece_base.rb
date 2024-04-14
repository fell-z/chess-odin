# This module has all methods and constants that are common to all standard chess pieces.
module PieceBase
  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    right: [0, 1],
    left: [0, -1],
    up_left: [-1, -1],
    up_right: [-1, 1],
    down_left: [1, -1],
    down_right: [1, 1]
  }.freeze

  FAILURE = false
  SUCCESS = true

  attr_reader :side, :position

  def initialize(board, side, position)
    @board = board
    @side = side
    @position = position

    @board.place_piece_at(@position, self)
  end

  def move(dest_pos)
    return FAILURE unless possible_moves.include?(dest_pos)

    @board.move_piece(@position, dest_pos)
    @position = dest_pos

    SUCCESS
  end

  def capture(piece_pos)
    return FAILURE unless possible_captures.include?(piece_pos)

    @board.remove_piece_at(piece_pos)

    @board.move_piece(@position, piece_pos)
    @position = piece_pos

    SUCCESS
  end
end

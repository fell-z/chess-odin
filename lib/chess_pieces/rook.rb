# Implementation of chess rook
class Rook
  RANK = 0
  FILE = 1

  attr_reader :side, :position

  def initialize(board, side, position)
    @board = board
    @side = side
    @position = position

    @board.place_piece_at(@position, self)
  end

  def to_s
    "♜"
  end
end

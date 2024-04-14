require_relative "./modules/piece_base"
require_relative "./modules/standard_movement"

# Implementation of chess rook
class Rook
  include PieceBase
  include StandardMovement

  attr_reader :first_move

  def initialize(board, side, position)
    super

    @first_move = true
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
    "♜"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up down right left].include?(direction) }
  end
end

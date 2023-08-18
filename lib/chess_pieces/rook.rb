require_relative "./modules/piece_base"
require_relative "./modules/standard_movement"

# Implementation of chess rook
class Rook
  include PieceBase
  include StandardMovement

  def to_s
    "♜"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up down right left].include?(direction) }
  end
end

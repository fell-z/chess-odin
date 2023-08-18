require_relative "./modules/piece_base"
require_relative "./modules/standard_movement"

# Implementation of chess bishop
class Bishop
  include PieceBase
  include StandardMovement

  def to_s
    "♝"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up_left down_left up_right down_right].include?(direction) }
  end
end

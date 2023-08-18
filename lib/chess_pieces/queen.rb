require_relative "./modules/piece_base"
require_relative "./modules/standard_movement"

# Implementation of chess queen
class Queen
  include PieceBase
  include StandardMovement

  def to_s
    "♛"
  end

  private

  def directions
    DIRECTIONS
  end
end

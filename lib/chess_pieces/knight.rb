require_relative "./modules/piece_base"
require_relative "./modules/special_movement"

# Implementation of chess knight
class Knight
  include PieceBase
  include SpecialMovement

  def to_s
    "♞"
  end

  private

  def directions
    {
      up_a: [-2, -1],
      up_b: [-2, 1],
      down_a: [2, -1],
      down_b: [2, 1],
      left_a: [-1, -2],
      left_b: [1, -2],
      right_a: [-1, 2],
      right_b: [1, 2]
    }
  end
end

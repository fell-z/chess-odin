require_relative "./modules/piece_base"
require_relative "./modules/special_movement"

# Implementation of chess king
class King
  include PieceBase
  include SpecialMovement

  def to_s
    "♚"
  end

  private

  def directions
    DIRECTIONS
  end
end

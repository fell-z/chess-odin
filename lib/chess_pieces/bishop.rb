require_relative "./piece_base"

# Implementation of chess bishop
class Bishop < PieceBase
  def possible_moves
    moves = []

    directions.each_value do |direction|
      squares_towards_to(direction).each do |square|
        break unless @board.at_position(square).nil?

        moves << square
      end
    end

    moves
  end

  def to_s
    "♝"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up_left down_left up_right down_right].include?(direction) }
  end
end

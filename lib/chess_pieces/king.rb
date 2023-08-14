require_relative "./piece_base"

# Implementation of chess king
class King < PieceBase
  def possible_moves
    moves = []

    DIRECTIONS.each_value do |direction|
      new_position = [@position, direction].transpose.map(&:sum)

      next unless new_position.all? { |value| value.between?(0, 7) }

      moves << new_position if @board.at_position(new_position).nil?
    end

    moves
  end

  def to_s
    "♚"
  end
end

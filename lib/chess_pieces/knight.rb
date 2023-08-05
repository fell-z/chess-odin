require_relative "./piece_base"

# Implementation of chess knight
class Knight < PieceBase
  def possible_moves
    moves = []

    directions.each_value do |direction|
      new_position = [@position, direction].transpose.map(&:sum)

      next unless new_position.all? { |value| value.between?(0, 7) }

      moves << new_position if @board.at_position(new_position).nil?
    end

    moves
  end

  def possible_captures
    captures = []

    directions.each_value do |direction|
      new_capture = [@position, direction].transpose.map(&:sum)

      next unless new_capture.all? { |value| value.between?(0, 7) }

      unless @board.at_position(new_capture).nil? || @board.at_position(new_capture).side == @side
        next captures << new_capture
      end
    end

    captures
  end

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

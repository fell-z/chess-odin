# This module contains the #possible_moves and #possible_captures specific to the King and Knight classes
module SpecialMovement
  def possible_moves
    moves = []

    directions.each_value do |direction|
      new_position = add(@position, direction)

      next unless new_position.all? { |value| value.between?(0, 7) }

      moves << new_position if @board.empty_at?(new_position)
    end

    moves
  end

  def possible_captures
    captures = []

    directions.each_value do |direction|
      new_capture = add(@position, direction)

      next unless new_capture.all? { |value| value.between?(0, 7) }

      unless @board.empty_at?(new_capture) || @board.at_position(new_capture).side == @side
        next captures << new_capture
      end
    end

    captures
  end

  private

  def add(position, direction)
    [position, direction].transpose.map(&:sum)
  end
end

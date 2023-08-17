require_relative "./modules/piece_base"

# Implementation of chess king
class King
  include PieceBase

  def possible_moves
    moves = []

    DIRECTIONS.each_value do |direction|
      new_position = [@position, direction].transpose.map(&:sum)

      next unless new_position.all? { |value| value.between?(0, 7) }

      moves << new_position if @board.at_position(new_position).nil?
    end

    moves
  end

  def possible_captures
    captures = []

    DIRECTIONS.each_value do |direction|
      new_capture = [@position, direction].transpose.map(&:sum)

      next unless new_capture.all? { |value| value.between?(0, 7) }

      unless @board.at_position(new_capture).nil? || @board.at_position(new_capture).side == @side
        next captures << new_capture
      end
    end

    captures
  end

  def to_s
    "♚"
  end
end

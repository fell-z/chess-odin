require_relative "./piece_base"

# Implementation of chess rook
class Rook < PieceBase
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

  def possible_captures
    captures = []

    directions.each_value do |direction|
      squares_towards_to(direction).each do |square|
        next if @board.at_position(square).nil?

        captures << square if @board.at_position(square).side != @side
        break
      end
    end

    captures
  end

  def to_s
    "♜"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up down right left].include?(direction) }
  end
end

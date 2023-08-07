require_relative "./piece_base"

# Implementation of chess queen
class Queen < PieceBase
  def possible_moves
    moves = []

    DIRECTIONS.each_value do |direction|
      squares_towards_to(direction).each do |square|
        break unless @board.at_position(square).nil?

        moves << square
      end
    end

    moves
  end

  def to_s
    "♛"
  end
end

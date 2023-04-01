# Implementation of chess rook
class Rook
  RANK = 0
  FILE = 1

  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    right: [0, 1],
    left: [0, -1]
  }.freeze

  attr_reader :side, :position

  def initialize(board, side, position)
    @board = board
    @side = side
    @position = position

    @board.place_piece_at(@position, self)
  end

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
    "♜"
  end

  private

  def directions
    DIRECTIONS.select { |direction| %i[up down right left].include?(direction) }
  end

  def squares_towards_to(direction)
    squares = []
    current_position = @position.dup

    while current_position.all? { |value| value.between?(0, 7) }
      current_position.map!.with_index { |value, index| value + direction[index] }
      squares << current_position.dup if current_position.all? { |value| value.between?(0, 7) }
    end

    squares
  end
end

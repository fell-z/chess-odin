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

  def possible_captures
    captures = []

    directions.each_value do |direction|
      squares_towards_to(direction).each do |square|
        next if @board.at_position(square).nil?

        break captures << square if @board.at_position(square).side != @side
      end
    end

    captures
  end

  def move(dest_pos)
    return :failure unless possible_moves.include?(dest_pos)

    @board.move_piece(@position, dest_pos)
    @position = dest_pos

    :success
  end

  def capture(piece_pos)
    return :failure unless possible_captures.include?(piece_pos)

    @board.remove_piece_at(piece_pos)

    @board.move_piece(@position, piece_pos)
    @position = piece_pos

    :success
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

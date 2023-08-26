# This module contains the #possible_moves and #possible_captures specific to the Rook, Bishop and Queen classes
module StandardMovement
  def possible_moves
    moves = []

    directions.each_value do |direction|
      squares_towards_to(direction).each do |square|
        break unless @board.empty_at?(square)

        moves << square
      end
    end

    moves
  end

  def possible_captures
    captures = []

    directions.each_value do |direction|
      squares_towards_to(direction).each do |square|
        next if @board.empty_at?(square)

        captures << square if @board.at_position(square).side != @side
        break
      end
    end

    captures
  end

  private

  def add(position, direction)
    [position, direction].transpose.map(&:sum)
  end

  def squares_towards_to(direction)
    squares = []
    current_position = @position.dup

    while current_position.all? { |value| value.between?(0, 7) }
      current_position = add(current_position, direction)
      squares << current_position.dup if current_position.all? { |value| value.between?(0, 7) }
    end

    squares
  end
end

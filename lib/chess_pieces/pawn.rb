require_relative "./modules/piece_base"

# Implementation of chess pawn
class Pawn
  include PieceBase

  def initialize(board, side, position)
    super

    @move_direction = position[0] == 1 ? :down : :up
    @first_move = true
  end

  def possible_moves
    moves = []

    moves << add(@position, direction_to_move)
    moves << add(@position, direction_to_move.map { |value| value * 2 }) if @first_move

    moves.select { |move| move.all? { |value| value.between?(0, 7) } && @board.at_position(move).nil? }
  end

  def possible_captures
    captures = []

    directions_to_capture.each_value do |direction|
      new_capture = add(@position, direction)

      next unless new_capture.all? { |value| value.between?(0, 7) }

      unless @board.at_position(new_capture).nil? || @board.at_position(new_capture).side == @side
        next captures << new_capture
      end
    end

    captures
  end

  def move(dest_pos)
    exit_code = super

    @first_move = false if exit_code == :success && @first_move

    exit_code
  end

  def capture(piece_pos)
    exit_code = super

    @first_move = false if exit_code == :success && @first_move

    exit_code
  end

  def to_s
    "♟"
  end

  private

  def add(position, direction)
    [position, direction].transpose.map(&:sum)
  end

  def direction_to_move
    {
      up: [-1, 0],
      down: [1, 0]
    }[@move_direction]
  end

  def directions_to_capture
    {
      left: add(direction_to_move, [0, -1]),
      right: add(direction_to_move, [0, 1])
    }
  end
end

require_relative "./piece_base"

# Implementation of chess pawn
class Pawn < PieceBase
  RANK = 0
  FILE = 1

  DOWN = 1
  UP = -1

  def initialize(board, side, position)
    super

    @move_direction = position[RANK] == 1 ? DOWN : UP
    @first_move = true
  end

  # rubocop:disable Metrics/MethodLength
  def possible_moves
    rank = @position[RANK]
    file = @position[FILE]

    moves =
      if @first_move
        [[rank + (1 * @move_direction), file], [rank + (2 * @move_direction), file]]
      else
        [[rank + (1 * @move_direction), file]]
      end

    moves.select do |move_pos|
      move_pos.all? { |value| value.between?(0, 7) } && @board.at_position(move_pos).nil?
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize
  def possible_captures
    current_rank = @position[RANK]
    current_file = @position[FILE]

    captures = [
      [current_rank + (1 * @move_direction), current_file - 1],
      [current_rank + (1 * @move_direction), current_file + 1]
    ].select { |capture_pos| capture_pos.all? { |value| value.between?(0, 7) } }

    captures.reject do |capture_pos|
      possible_capture = @board.at_position(capture_pos)
      possible_capture.nil? || possible_capture.side == @side
    end
  end
  # rubocop:enable Metrics/AbcSize

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
end

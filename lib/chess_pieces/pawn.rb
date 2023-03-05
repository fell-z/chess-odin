# Implementation of chess pawn
class Pawn
  RANK = 0
  FILE = 1

  DOWN = 1
  UP = -1

  attr_reader :side, :position

  def initialize(board, side, position)
    @board = board
    @side = side
    @position = position
    @move_direction = position[RANK] == 1 ? DOWN : UP
    @first_move = true

    @board.place_piece_at(@position, self)
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
      (move_pos[RANK].between?(0, 7) && move_pos[FILE].between?(0, 7)) && @board.at_position(move_pos).nil?
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
    ].select { |capture_pos| capture_pos[RANK].between?(0, 7) && capture_pos[FILE].between?(0, 7) }

    captures.reject do |capture_pos|
      possible_capture = @board.at_position(capture_pos)
      possible_capture.nil? || possible_capture.side == @side
    end
  end
  # rubocop:enable Metrics/AbcSize

  def move(dest_pos)
    return :failure unless possible_moves.include?(dest_pos)

    @first_move = false

    @board.move_piece(@position, dest_pos)
    @position = dest_pos

    :success
  end

  def capture(piece_pos)
    return :failure unless possible_captures.include?(piece_pos)

    @first_move = false

    @board.remove_piece_at(piece_pos)

    @board.move_piece(@position, piece_pos)
    @position = piece_pos

    :success
  end

  def to_s
    "♟"
  end
end

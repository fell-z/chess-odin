# Implementation of a chess board with basic methods
# to render and update the board itself
class Board
  COLORS = {
    bg: {
      purple: [187, 120, 247],
      blue: [85, 85, 255]
    },
    fg: {
      white: [255, 255, 255],
      black: [0, 0, 0]
    }
  }.freeze

  RANK = 0
  FILE = 1

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def render
    system("clear")
    bg_color_sequence = %i[purple blue purple blue purple blue purple blue]

    puts "┌#{'────────' * 8}┐"
    @board.each do |rank|
      fg_color_sequence = rank.map { |piece| piece.nil? ? :white : piece.side }
      rank = rank.map { |piece| piece.nil? ? " " : piece.to_s }

      puts build_rank(bg_color_sequence, fg_color_sequence, rank)
      bg_color_sequence.rotate!
    end
    puts "└#{'────────' * 8}┘"
  end

  def at_position(position)
    @board[position[RANK]][position[FILE]]
  end

  def place_piece_at(position, new_piece)
    @board[position[RANK]][position[FILE]] = new_piece
  end

  def remove_piece_at(position)
    @board[position[RANK]][position[FILE]] = nil
  end

  def move_piece(piece_pos, dest_pos)
    place_piece_at(dest_pos, at_position(piece_pos))
    remove_piece_at(piece_pos)
  end

  private

  def build_rank(bg_color_sequence, fg_color_sequence, rank_squares)
    blank_line_squares = "        " * 8
    blank_line_color_sequence = [:white] * 8
    <<~RANK
      │#{build_line(bg_color_sequence, blank_line_color_sequence, blank_line_squares)}│
      │#{build_line(bg_color_sequence, fg_color_sequence, rank_squares)}│
      │#{build_line(bg_color_sequence, blank_line_color_sequence, blank_line_squares)}│
    RANK
  end

  def build_line(bg_color_sequence, fg_color_sequence, mid_points)
    bg_color_sequence.each_with_index.reduce("") do |line, (bg_color, index)|
      line + colorize(mid_points[index].center(8), COLORS[:bg][bg_color], COLORS[:fg][fg_color_sequence[index]])
    end
  end

  def colorize(char, background_values, foreground_values = COLORS[:fg][:white])
    bg = background_values.join(";")
    fg = foreground_values.join(";")
    "\e[48;2;#{bg};38;2;#{fg}m#{char}\e[0m"
  end
end

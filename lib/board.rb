# Implementation of a chess board with basic methods
# to render and update the board itself
class Board
  COLORS = {
    bg: {
      magenta: [187, 120, 247],
      blue: [85, 85, 255]
    },
    fg: {
      white: [255, 255, 255],
      black: [0, 0, 0]
    }
  }.freeze

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def render
    bg_color_sequence = %i[magenta blue magenta blue magenta blue magenta blue]

    puts "┌#{'────────' * 8}┐"
    @board.each do |rank|
      fg_color_sequence = rank.map { |piece| piece.nil? ? :white : piece.side }
      rank = rank.map { |piece| piece.nil? ? " " : piece.to_s }

      puts build_rank(bg_color_sequence, fg_color_sequence, rank)
      bg_color_sequence.rotate!
    end
    puts "└#{'────────' * 8}┘"
  end

  private

  def build_rank(bg_color_sequence, fg_color_sequence, rank_squares)
    side_corner = "│"
    blank_line_squares = "        " * 8
    blank_line_color_sequence = [:white] * 8
    <<~RANK
      #{build_line(bg_color_sequence, blank_line_color_sequence, side_corner, blank_line_squares, side_corner)}
      #{build_line(bg_color_sequence, fg_color_sequence, side_corner, rank_squares, side_corner)}
      #{build_line(bg_color_sequence, blank_line_color_sequence, side_corner, blank_line_squares, side_corner)}
    RANK
  end

  def build_line(bg_color_sequence, fg_color_sequence, left_corner, mid_points, right_corner)
    finished_line = bg_color_sequence.each_with_index.reduce("") do |line, (bg_color, index)|
      line + colorize(mid_points[index].center(8), COLORS[:bg][bg_color], COLORS[:fg][fg_color_sequence[index]])
    end
    left_corner + finished_line + right_corner
  end

  def colorize(char, background_values, foreground_values = COLORS[:fg][:white])
    bg = background_values.join(";")
    fg = foreground_values.join(";")
    "\e[48;2;#{bg};38;2;#{fg}m#{char}\e[0m"
  end
end

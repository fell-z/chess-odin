require_relative "./input_parser"

# Implementation of a player, with methods to ask for a input(be a move or some decision) and etc.
class Player
  def input
    gets.chomp
  end

  def play_input
    player_input = input

    parsed_castling = InputParser.parse_castling(player_input)
    return { piece: King }.merge(parsed_castling) if parsed_castling[:castling?]

    play = InputParser.parse_all_data(player_input)
    return :failure if play == :failure

    indexes = InputParser.parse_all_indexes(player_input)
    return :failure unless indexes == indexes.sort

    play
  end
end

# It simply has methods to parse the player input, like the piece and type of play
module InputParser
  module_function

  FAILURE = false

  PIECES = {
    "K" => King,
    "N" => Knight,
    "Q" => Queen,
    "B" => Bishop,
    "R" => Rook
  }.freeze

  FILES = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }.freeze

  RANKS = {
    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }.freeze

  # rubocop:disable Metrics/AbcSize
  def parse_all_data(input)
    play = {}

    play[:piece] = parse_piece(input)[:data]
    play[:origin] = parse_origin(input)[:data]
    play[:type] = parse_type(input)[:data]

    play[:dest_pos] = parse_dest_pos(input)[:data]
    play[:promotion_piece] = parse_promotion(input)[:data]

    return FAILURE if play.value?(FAILURE)
    return FAILURE if play[:piece] != Pawn && play[:promotion_piece]

    play.delete(:promotion_piece) unless play[:piece] == Pawn

    play
  end
  # rubocop:enable Metrics/AbcSize

  def parse_all_indexes(input)
    indexes = []

    indexes << parse_origin(input)[:index]
    indexes << parse_type(input)[:index]
    indexes << parse_dest_pos(input)[:index]

    parsed_promotion = parse_promotion(input)
    indexes << parsed_promotion[:index] if parsed_promotion[:data]

    indexes
  end

  def parse_piece(input)
    matched_piece = input.match(/^[KNQBR]/)
    matched_invalid = input.match(/[^=][KNQBR]/)

    return { data: FAILURE } if matched_invalid
    return { data: Pawn, index: 0 } unless matched_piece

    { data: PIECES[matched_piece[0]], index: matched_piece.begin(0) }
  end

  def parse_origin(input)
    dest_pos_index = parse_dest_pos(input)[:index]

    return { data: nil, index: 0 } if dest_pos_index.zero?

    origin_file = input[0..dest_pos_index - 1].match(/[a-h]/)
    origin_rank = input[0..dest_pos_index - 1].match(/[1-8]/)

    return { data: nil, index: 0 } unless origin_file || origin_rank

    return { data: FILES[origin_file[0]], index: origin_file.begin(0) } if origin_file

    { data: RANKS[origin_rank[0]], index: origin_rank.begin(0) }
  rescue NoMethodError
    { data: FAILURE }
  end

  def parse_type(input)
    return { data: :move, index: parse_dest_pos(input)[:index] } unless input.include?("x")

    { data: :capture, index: input.index("x") }
  end

  def parse_dest_pos(input)
    matched_dest_pos = input.match(/[a-h][1-8]/)

    input_rank = matched_dest_pos[0][1]
    input_file = matched_dest_pos[0][0]

    { data: [RANKS[input_rank], FILES[input_file]], index: matched_dest_pos.begin(0) }
  rescue NoMethodError
    { data: FAILURE }
  end

  def parse_promotion(input)
    matched_promotion = input.match(/=[NQBR]/)

    if matched_promotion
      return {
        data: PIECES[matched_promotion[0][1]],
        index: matched_promotion.begin(0)
      }
    end

    return { data: FAILURE } if input.match(/=\w/)

    { data: nil }
  end

  def parse_castling(input)
    case input
    when "0-0-0"
      { castling?: true, castling_type: :queenside }
    when "0-0"
      { castling?: true, castling_type: :kingside }
    else
      { castling?: false }
    end
  end
end

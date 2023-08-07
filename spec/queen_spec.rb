require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/queen"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Queen do
  let(:position) { [0, 3] }
  let(:board) { Board.new }
  subject(:queen) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"
end

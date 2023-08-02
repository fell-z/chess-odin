require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/bishop"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Bishop do
  let(:position) { [0, 2] }
  let(:board) { Board.new }
  subject(:bishop) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"
end

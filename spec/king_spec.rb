require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/king"
require_relative "../lib/board"

# rubocop:disable Metrics

describe King do
  let(:position) { [0, 4] }
  let(:board) { Board.new }
  subject(:king) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"
end

require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/knight"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Knight do
  let(:position) { [0, 1] }
  let(:board) { Board.new }
  subject(:knight) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"
end

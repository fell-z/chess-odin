require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/pawn"
require_relative "../lib/board"

describe Pawn do
  subject(:pawn) { described_class.new(board, :white, [6, 0]) }
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:at_position)
    allow(board).to receive(:place_piece_at)
    allow(board).to receive(:move_piece)
    allow(board).to receive(:remove_piece_at)
  end

  it_behaves_like "a subclass of PieceBase"
end

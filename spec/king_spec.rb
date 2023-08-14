require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/king"
require_relative "../lib/board"

# rubocop:disable Metrics

describe King do
  let(:position) { [0, 4] }
  let(:board) { Board.new }
  subject(:king) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "when it's in" do
      context "one of the default positions, e8" do
        let(:position) { [0, 4] }

        it "doesn't include the positions c6, g8 and e5" do
          computed_moves = king.possible_moves
          invalid_moves = [[2, 2], [0, 6], [3, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions d7, e7 and f8" do
          computed_moves = king.possible_moves
          valid_moves = [[1, 3], [1, 4], [0, 5]]
          expect(computed_moves).to include(*valid_moves)
        end
      end
    end
  end
end

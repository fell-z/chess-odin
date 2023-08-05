require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/knight"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Knight do
  let(:position) { [0, 1] }
  let(:board) { Board.new }
  subject(:knight) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "when it's in" do
      context "one of the default positions, in b8" do
        let(:position) { [0, 1] }

        it "includes the positions c6 and d7" do
          computed_moves = knight.possible_moves
          valid_moves = [[2, 2], [1, 3]]
          expect(computed_moves).to include(*valid_moves)
        end

        it "doesn't include the positions c7 and e7" do
          computed_moves = knight.possible_moves
          invalid_moves = [[1, 2], [1, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end
      end
    end
  end
end

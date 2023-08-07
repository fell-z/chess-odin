require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/queen"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Queen do
  let(:position) { [0, 3] }
  let(:board) { Board.new }
  subject(:queen) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "when it's in" do
      context "one of the default positions, d8" do
        let(:position) { [0, 3] }

        it "doesn't include the positions c6 and e6" do
          computed_moves = queen.possible_moves
          invalid_moves = [[2, 2], [2, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions a5, f8 and d4" do
          computed_moves = queen.possible_moves
          valid_moves = [[3, 0], [0, 5], [4, 3]]
          expect(computed_moves).to include(*valid_moves)
        end
      end
    end
  end
end

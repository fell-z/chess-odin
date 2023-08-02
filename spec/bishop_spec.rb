require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/bishop"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Bishop do
  let(:position) { [0, 2] }
  let(:board) { Board.new }
  subject(:bishop) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "when it's in the" do
      context "one of the default positions, c8" do
        let(:position) { [0, 2] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          expect(computed_moves).to_not include([2, 1], [2, 3], [0, 1], [0, 3], [1, 2], [2, 2])
        end
      end

      context "one of the default positions, f8" do
        let(:position) { [0, 5] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          expect(computed_moves).to_not include([0, 4], [0, 6], [1, 5], [2, 5], [2, 4], [2, 6])
        end
      end

      context "one of the default positions, c1" do
        let(:position) { [7, 2] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          expect(computed_moves).to_not include([7, 1], [7, 3], [6, 2], [5, 2], [5, 1], [5, 3])
        end
      end

      context "one of the default positions, f1" do
        let(:position) { [7, 5] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          expect(computed_moves).to_not include([7, 4], [7, 6], [6, 5], [5, 5], [5, 4], [5, 6])
        end
      end
    end
  end
end

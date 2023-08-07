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

        context "with two pieces obstructing the way, in f6 and b8" do
          before do
            described_class.new(board, :white, [2, 5])
            described_class.new(board, :white, [0, 1])
          end

          it "doesn't include the positions f6, b8 and the ones after it" do
            computed_moves = queen.possible_moves
            invalid_moves = [[2, 5], [3, 6], [0, 1], [0, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end

          it "includes the positions c8 and e7" do
            computed_moves = queen.possible_moves
            valid_moves = [[0, 2], [1, 4]]
            expect(computed_moves).to include(*valid_moves)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        it "doesn't include the positions b5 and e2" do
          computed_moves = queen.possible_moves
          invalid_moves = [[3, 1], [6, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions b4, d5, f6 and a1" do
          computed_moves = queen.possible_moves
          valid_moves = [[4, 1], [3, 3], [2, 5], [7, 0]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with three pieces obstructing the way, in d3, b6 and a4" do
          before do
            described_class.new(board, :white, [5, 3])
            described_class.new(board, :white, [2, 1])
            described_class.new(board, :white, [4, 0])
          end

          it "doesn't include the positions d3, b6, a4 and the ones after it" do
            computed_moves = queen.possible_moves
            invalid_moves = [[5, 3], [2, 1], [1, 0], [4, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end

          it "includes the positions c5 and b4" do
            computed_moves = queen.possible_moves
            valid_moves = [[3, 2], [4, 1]]
            expect(computed_moves).to include(*valid_moves)
          end
        end
      end
    end
  end
end

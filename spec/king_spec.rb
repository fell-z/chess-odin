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

        context "with two pieces obstructing the way, in d7 and f8" do
          before do
            described_class.new(board, :white, [1, 3])
            described_class.new(board, :white, [0, 5])
          end

          it "doesn't include the positions f6, b8" do
            computed_moves = king.possible_moves
            invalid_moves = [[1, 3], [0, 5]]
            expect(computed_moves).to_not include(*invalid_moves)
          end

          it "includes the positions d8 and e7" do
            computed_moves = king.possible_moves
            valid_moves = [[0, 3], [1, 4]]
            expect(computed_moves).to include(*valid_moves)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        it "doesn't include the positions b4, d2 and f6" do
          computed_moves = king.possible_moves
          invalid_moves = [[4, 1], [6, 3], [2, 5]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions c5, d3, and e4" do
          computed_moves = king.possible_moves
          valid_moves = [[3, 2], [5, 3], [4, 4]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with three pieces obstructing the way, in d5, c3 and e3" do
          before do
            described_class.new(board, :white, [3, 3])
            described_class.new(board, :white, [5, 2])
            described_class.new(board, :white, [5, 4])
          end

          it "doesn't include the positions d5, c3, e3" do
            computed_moves = king.possible_moves
            invalid_moves = [[3, 3], [5, 2], [5, 4]]
            expect(computed_moves).to_not include(*invalid_moves)
          end

          it "includes the positions c4 and d3" do
            computed_moves = king.possible_moves
            valid_moves = [[4, 2], [5, 3]]
            expect(computed_moves).to include(*valid_moves)
          end
        end
      end
    end
  end
end

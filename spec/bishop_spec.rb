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
          invalid_moves = [[2, 1], [2, 3], [0, 1], [0, 3], [1, 2], [2, 2]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "with one piece obstructing the way, in b7" do
          before { described_class.new(board, :white, [1, 1]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[1, 1], [2, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with two pieces obstructing the way, one in b7 and one in f5" do
          before do
            described_class.new(board, :white, [1, 1])
            described_class.new(board, :white, [3, 5])
          end

          it "doesn't include those piece's positions and the ones after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[1, 1], [2, 0], [3, 5], [4, 6]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "one of the default positions, f8" do
        let(:position) { [0, 5] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[0, 4], [0, 6], [1, 5], [2, 5], [2, 4], [2, 6]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "with one piece obstructing the way, in b4" do
          before { described_class.new(board, :white, [4, 1]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[4, 1], [5, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with two pieces obstructing the way, one in c5 and one in f6" do
          before do
            described_class.new(board, :white, [3, 2])
            described_class.new(board, :white, [2, 7])
          end

          it "doesn't include those piece's positions and the ones after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[3, 2], [4, 1], [2, 7]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "one of the default positions, c1" do
        let(:position) { [7, 2] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[7, 1], [7, 3], [6, 2], [5, 2], [5, 1], [5, 3]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "with one piece obstructing the way, in e3" do
          before { described_class.new(board, :white, [5, 4]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[5, 4], [4, 5]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with two pieces obstructing the way, one in b2 and one in d2" do
          before do
            described_class.new(board, :white, [6, 1])
            described_class.new(board, :white, [6, 3])
          end

          it "returns an empty array of moves" do
            computed_moves = bishop.possible_moves
            expect(computed_moves).to be_empty
          end
        end
      end

      context "one of the default positions, f1" do
        let(:position) { [7, 5] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[7, 4], [7, 6], [6, 5], [5, 5], [5, 4], [5, 6]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "with one piece obstructing the way, in g2" do
          before { described_class.new(board, :white, [6, 6]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[6, 6], [5, 7]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with two pieces obstructing the way, one in a6 and one in h3" do
          before do
            described_class.new(board, :white, [2, 0])
            described_class.new(board, :white, [5, 7])
          end

          it "doesn't include those piece's positions" do
            computed_moves = bishop.possible_moves
            invalid_moves = [[2, 0], [5, 7]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "center, in d4" do
        let(:position) { [4, 3] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[3, 3], [5, 3], [4, 2], [4, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "while surrounded by pieces obstructing the way" do
          before do
            described_class.new(board, :white, [3, 2])
            described_class.new(board, :white, [3, 4])
            described_class.new(board, :white, [5, 2])
            described_class.new(board, :white, [5, 4])
          end

          it "returns an empty array of moves" do
            computed_moves = bishop.possible_moves
            expect(computed_moves).to be_empty
          end
        end
      end
    end
  end
end

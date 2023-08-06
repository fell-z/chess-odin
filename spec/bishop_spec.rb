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
    context "when it's in" do
      context "one of the default positions, c8" do
        let(:position) { [0, 2] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[2, 1], [2, 3], [0, 1], [0, 3], [1, 2], [2, 2]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions f5 and a6" do
          computed_moves = bishop.possible_moves
          valid_moves = [[3, 5], [2, 0]]
          expect(computed_moves).to include(*valid_moves)
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

        it "includes the positions b4 and g7" do
          computed_moves = bishop.possible_moves
          valid_moves = [[4, 1], [1, 6]]
          expect(computed_moves).to include(*valid_moves)
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

        it "includes the positions e3 and g5" do
          computed_moves = bishop.possible_moves
          valid_moves = [[5, 4], [3, 6]]
          expect(computed_moves).to include(*valid_moves)
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

        it "includes the positions e2 and a6" do
          computed_moves = bishop.possible_moves
          valid_moves = [[6, 4], [2, 0]]
          expect(computed_moves).to include(*valid_moves)
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

      context "the center, in d4" do
        let(:position) { [4, 3] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = bishop.possible_moves
          invalid_moves = [[3, 3], [5, 3], [4, 2], [4, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions c3, g7 and b6" do
          computed_moves = bishop.possible_moves
          valid_moves = [[5, 2], [1, 6], [2, 1]]
          expect(computed_moves).to include(*valid_moves)
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

  describe "#possible_captures" do
    context "when it's in" do
      context "one of the default positions, in c8" do
        let(:position) { [0, 2] }

        context "with an enemy's piece in e6" do
          before { described_class.new(board, :black, [2, 4]) }

          it "returns that enemy's position" do
            computed_captures = bishop.possible_captures
            valid_captures = [[2, 4]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with two enemy's pieces in range, one in a6 and one in g4" do
          before do
            described_class.new(board, :black, [2, 0])
            described_class.new(board, :black, [4, 6])
          end

          it "returns those enemy's positions" do
            computed_captures = bishop.possible_captures
            valid_captures = [[4, 6], [2, 0]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with two enemy's pieces in the same direction, one in f5 and one in g4" do
          before do
            described_class.new(board, :black, [3, 5])
            described_class.new(board, :black, [4, 6])
          end

          it "returns only one of those enemy's positions, the first of them" do
            computed_captures = bishop.possible_captures
            valid_captures = [[3, 5]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end

      context "the center, in e4" do
        let(:position) { [4, 4] }

        context "while surrounded by enemy's pieces" do
          before do
            described_class.new(board, :black, [3, 3])
            described_class.new(board, :black, [3, 5])
            described_class.new(board, :black, [5, 3])
            described_class.new(board, :black, [5, 5])
          end

          it "returns all of those enemy's positions" do
            computed_captures = bishop.possible_captures
            valid_captures = [[3, 3], [3, 5], [5, 3], [5, 5]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with an allied piece in f5 and a enemy's piece in g6" do
          before do
            described_class.new(board, :white, [3, 5])
            described_class.new(board, :black, [2, 6])
          end

          it "returns an empty array of captures" do
            computed_captures = bishop.possible_captures
            expect(computed_captures).to be_empty
          end
        end
      end
    end
  end
end

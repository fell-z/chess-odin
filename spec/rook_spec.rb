require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/rook"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Rook do
  let(:board) { Board.new }
  let(:position) { [0, 0] }
  subject(:rook) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "when it's in" do
      context "the top left corner, in a8" do
        let(:position) { [0, 0] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = rook.possible_moves
          invalid_moves = [[1, 1], [2, 1], [1, 2], [2, 2]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions a5 and e8" do
          computed_moves = rook.possible_moves
          valid_moves = [[3, 0], [0, 4]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with one piece obstructing the way, in f8" do
          before { described_class.new(board, :white, [0, 5]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[0, 5], [0, 6]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with one piece obstructing the way, in a3" do
          before { described_class.new(board, :white, [5, 0]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[5, 0], [6, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "the top right corner, in h8" do
        let(:position) { [0, 7] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = rook.possible_moves
          invalid_moves = [[1, 6], [2, 6], [1, 5], [2, 5]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions h1 and g8" do
          computed_moves = rook.possible_moves
          valid_moves = [[7, 7], [0, 6]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with one piece obstructing the way, in c8" do
          before { described_class.new(board, :white, [0, 2]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[0, 2], [0, 1]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with one piece obstructing the way, in h3" do
          before { described_class.new(board, :white, [5, 7]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[5, 7], [6, 7]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "the bottom left corner, in a1" do
        let(:position) { [7, 0] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = rook.possible_moves
          invalid_moves = [[6, 1], [6, 2], [5, 1], [5, 2]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions f1 and a7" do
          computed_moves = rook.possible_moves
          valid_moves = [[7, 5], [1, 0]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with one piece obstructing the way, in f1" do
          before { described_class.new(board, :white, [7, 5]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[7, 5], [7, 6]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with one piece obstructing the way, in a6" do
          before { described_class.new(board, :white, [2, 0]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[2, 0], [1, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "the bottom right corner, in h1" do
        let(:position) { [7, 7] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = rook.possible_moves
          invalid_moves = [[6, 6], [6, 5], [5, 6], [5, 5]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions h6 and b1" do
          computed_moves = rook.possible_moves
          valid_moves = [[2, 7], [7, 1]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "with one piece obstructing the way, in c1" do
          before { described_class.new(board, :white, [7, 2]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[7, 2], [7, 1]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end

        context "with one piece obstructing the way, in h6" do
          before { described_class.new(board, :white, [2, 7]) }

          it "doesn't include that piece's position and the next after it" do
            computed_moves = rook.possible_moves
            invalid_moves = [[2, 7], [1, 7]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        it "doesn't include those invalid moves near itself" do
          computed_moves = rook.possible_moves
          invalid_moves = [[3, 2], [3, 4], [5, 2], [5, 4]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        it "includes the positions d2, h4 and d8" do
          computed_moves = rook.possible_moves
          valid_moves = [[6, 3], [4, 7], [0, 3]]
          expect(computed_moves).to include(*valid_moves)
        end

        context "while surrounded by pieces obstructing the way" do
          before do
            described_class.new(board, :white, [4, 2])
            described_class.new(board, :white, [4, 4])
            described_class.new(board, :white, [3, 3])
            described_class.new(board, :white, [5, 3])
          end

          it "returns an empty array of moves" do
            computed_moves = rook.possible_moves
            expect(computed_moves).to be_empty
          end
        end
      end
    end
  end

  describe "#possible_captures" do
    context "when it's in" do
      context "the top left corner, in a8" do
        let(:position) { [0, 0] }

        context "with an enemy's piece in a5" do
          before { described_class.new(board, :black, [3, 0]) }

          it "returns that enemy's position" do
            computed_captures = rook.possible_captures
            valid_captures = [[3, 0]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with an enemy's piece in f8" do
          before { described_class.new(board, :black, [0, 5]) }

          it "returns that enemy's position" do
            computed_captures = rook.possible_captures
            valid_captures = [[0, 5]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with two enemy's pieces in range, one in a6 and one in d8" do
          before do
            described_class.new(board, :black, [2, 0])
            described_class.new(board, :black, [0, 3])
          end

          it "returns those enemy's positions" do
            computed_captures = rook.possible_captures
            valid_captures = [[2, 0], [0, 3]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with two enemy's pieces in the same direction, one in c8 and one in e8" do
          before do
            described_class.new(board, :black, [0, 2])
            described_class.new(board, :black, [0, 4])
          end

          it "returns only one of those enemy's positions, the first of them" do
            computed_captures = rook.possible_captures
            valid_captures = [[0, 2]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        context "while surrounded by enemy's pieces" do
          before do
            described_class.new(board, :black, [4, 5])
            described_class.new(board, :black, [4, 1])
            described_class.new(board, :black, [6, 3])
            described_class.new(board, :black, [2, 3])
          end

          it "returns all of those enemy's positions" do
            computed_captures = rook.possible_captures
            valid_captures = [[4, 5], [4, 1], [6, 3], [2, 3]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with an allied piece in d3 and a enemy's piece in d2" do
          before do
            described_class.new(board, :white, [5, 3])
            described_class.new(board, :black, [6, 3])
          end

          it "returns an empty array of captures" do
            computed_captures = rook.possible_captures
            expect(computed_captures).to be_empty
          end
        end
      end
    end
  end
end

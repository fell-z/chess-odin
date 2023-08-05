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

        context "with one piece occupying in a6" do
          before { described_class.new(board, :white, [2, 0]) }

          it "includes the position c6" do
            computed_moves = knight.possible_moves
            valid_moves = [[2, 2]]
            expect(computed_moves).to include(*valid_moves)
          end

          it "doesn't include the position a6" do
            computed_moves = knight.possible_moves
            invalid_moves = [[2, 0]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        it "includes the positions e2, f5, b3 and e6" do
          computed_moves = knight.possible_moves
          valid_moves = [[6, 4], [3, 5], [5, 1], [2, 4]]
          expect(computed_moves).to include(*valid_moves)
        end

        it "doesn't include the positions d6, c4 and g5" do
          computed_moves = knight.possible_moves
          invalid_moves = [[2, 3], [4, 2], [3, 6]]
          expect(computed_moves).to_not include(*invalid_moves)
        end

        context "with two pieces occupying the c6 and f3" do
          before do
            described_class.new(board, :white, [2, 2])
            described_class.new(board, :white, [5, 5])
          end

          it "doesn't include the positions c6 and f3" do
            computed_moves = knight.possible_moves
            invalid_moves = [[2, 2], [5, 5]]
            expect(computed_moves).to_not include(*invalid_moves)
          end
        end
      end
    end
  end

  describe "#possible_captures" do
    context "when it's in" do
      context "one of the default positions, in g8" do
        let(:position) { [0, 6] }

        context "with an enemy's piece in f6" do
          before { described_class.new(board, :black, [2, 5]) }

          it "returns that enemy's position" do
            computed_captures = knight.possible_captures
            valid_captures = [[2, 5]]
            expect(computed_captures).to include(*valid_captures)
          end
        end

        context "with two enemy's pieces in range, one in e7 and one in h6" do
          before do
            described_class.new(board, :black, [1, 4])
            described_class.new(board, :black, [2, 7])
          end

          it "returns those enemy's positions" do
            computed_captures = knight.possible_captures
            valid_captures = [[1, 4], [2, 7]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        context "with four enemy's pieces in range, in: c2, b5, f3 and e6" do
          before do
            described_class.new(board, :black, [6, 2])
            described_class.new(board, :black, [3, 1])
            described_class.new(board, :black, [5, 5])
            described_class.new(board, :black, [2, 4])
          end

          it "returns all of those enemy's positions" do
            computed_captures = knight.possible_captures
            valid_captures = [[6, 2], [3, 1], [5, 5], [2, 4]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end
    end
  end
end

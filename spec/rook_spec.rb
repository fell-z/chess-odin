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
    context "when it's in the" do
      context "top left corner" do
        let(:position) { [0, 0] }

        it "returns only two directions to move to" do
          computed_moves = rook.possible_moves
          result = computed_moves.all? { |pos| pos[0] >= 0 && pos[1] >= 0 }
          expect(result).to be_truthy
        end

        context "and it has a piece obstructing in the same rank" do
          let!(:obstructive_piece) { described_class.new(board, :white, [0, 5]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] >= 0 && pos[1] < 5 }
            expect(result).to be_truthy
          end
        end

        context "and it has a piece obstructing in the same file" do
          let!(:obstructive_piece) { described_class.new(board, :white, [5, 0]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] < 5 && pos[1] >= 0 }
            expect(result).to be_truthy
          end
        end
      end

      context "top right corner" do
        let(:position) { [0, 7] }

        it "returns only two directions to move to" do
          computed_moves = rook.possible_moves
          result = computed_moves.all? { |pos| pos[0] >= 0 && pos[1] <= 7 }
          expect(result).to be_truthy
        end

        context "and it has a piece obstructing in the same rank" do
          let!(:obstructive_piece) { described_class.new(board, :white, [0, 2]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] >= 0 && pos[1] > 2 }
            expect(result).to be_truthy
          end
        end

        context "and it has a piece obstructing in the same file" do
          let!(:obstructive_piece) { described_class.new(board, :white, [5, 7]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] < 5 && pos[1] <= 7 }
            expect(result).to be_truthy
          end
        end
      end

      context "bottom left corner" do
        let(:position) { [7, 0] }

        it "returns only two directions to move to" do
          computed_moves = rook.possible_moves
          result = computed_moves.all? { |pos| pos[0] <= 7 && pos[1] >= 0 }
          expect(result).to be_truthy
        end

        context "and it has a piece obstructing in the same rank" do
          let!(:obstructive_piece) { described_class.new(board, :white, [7, 5]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] <= 7 && pos[1] < 5 }
            expect(result).to be_truthy
          end
        end

        context "and it has a piece obstructing in the same file" do
          let!(:obstructive_piece) { described_class.new(board, :white, [2, 0]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] > 2 && pos[1] >= 0 }
            expect(result).to be_truthy
          end
        end
      end

      context "bottom right corner" do
        let(:position) { [7, 7] }

        it "returns only two directions to move to" do
          computed_moves = rook.possible_moves
          result = computed_moves.all? { |pos| pos[0] <= 7 && pos[1] <= 7 }
          expect(result).to be_truthy
        end

        context "and it has a piece obstructing in the same rank" do
          let!(:obstructive_piece) { described_class.new(board, :white, [7, 2]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] <= 7 && pos[1] > 2 }
            expect(result).to be_truthy
          end
        end

        context "and it has a piece obstructing in the same file" do
          let!(:obstructive_piece) { described_class.new(board, :white, [2, 7]) }

          it "returns only possible moves before the obstructing piece" do
            computed_moves = rook.possible_moves
            result = computed_moves.all? { |pos| pos[0] > 2 && pos[1] <= 7 }
            expect(result).to be_truthy
          end
        end
      end

      context "middle" do
        let(:position) { [4, 3] }

        it "returns moves in all possible directions" do
          computed_moves = rook.possible_moves
          result = computed_moves.all? { |pos| pos[0].between?(0, 7) && pos[1].between?(0, 7) }
          expect(result).to be_truthy
        end
      end

      context "corner trapped by two other pieces" do
        let(:position) { [0, 0] }
        let!(:rank_obstructing_piece) { described_class.new(board, :white, [1, 0]) }
        let!(:file_obstructing_piece) { described_class.new(board, :white, [0, 1]) }

        it "returns an empty array of moves" do
          computed_moves = rook.possible_moves
          expect(computed_moves).to be_empty
        end
      end
    end
  end

  describe "#possible_captures" do
    context "when a piece it's in the same rank" do
      let(:position) { [0, 0] }
      let!(:rank_enemy_piece) { described_class.new(board, :black, [0, 5]) }

      it "returns that enemy's position" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([0, 5])
      end
    end

    context "when a piece it's in the same file" do
      let(:position) { [0, 0] }
      let!(:file_enemy_piece) { described_class.new(board, :black, [5, 0]) }

      it "returns that enemy's position" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([5, 0])
      end
    end

    context "when there's two pieces, one in the same rank and one in the same file" do
      let(:position) { [0, 0] }
      let!(:rank_enemy_piece) { described_class.new(board, :black, [0, 5]) }
      let!(:file_enemy_piece) { described_class.new(board, :black, [5, 0]) }

      it "returns those two enemy's positions" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([0, 5], [5, 0])
      end
    end

    context "when there's four pieces, in all directions" do
      let(:position) { [4, 3] }
      let!(:first_enemy_piece) { described_class.new(board, :black, [4, 5]) }
      let!(:second_enemy_piece) { described_class.new(board, :black, [4, 1]) }
      let!(:third_enemy_piece) { described_class.new(board, :black, [6, 3]) }
      let!(:fourth_enemy_piece) { described_class.new(board, :black, [2, 3]) }

      it "returns all of those enemy's positions" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([4, 5], [4, 1], [6, 3], [2, 3])
      end
    end

    context "when there's two pieces in the same rank, but different files" do
      let(:position) { [0, 0] }
      let!(:first_enemy_piece) { described_class.new(board, :black, [0, 3]) }
      let!(:second_enemy_piece) { described_class.new(board, :black, [0, 5]) }

      it "returns only one of those two enemy's position, the first of them" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([0, 3])
      end
    end

    context "when there's two pieces in the same file, but different ranks" do
      let(:position) { [0, 0] }
      let!(:first_enemy_piece) { described_class.new(board, :black, [3, 0]) }
      let!(:second_enemy_piece) { described_class.new(board, :black, [5, 0]) }

      it "returns only one of those two enemy's position, the first of them" do
        computed_captures = rook.possible_captures
        expect(computed_captures).to include([3, 0])
      end
    end
  end
end

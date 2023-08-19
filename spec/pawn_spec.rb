require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/pawn"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Pawn do
  let(:position) { [6, 0] }
  let(:board) { Board.new }
  subject(:pawn) { described_class.new(board, :white, position) }

  it_behaves_like "a subclass of PieceBase"

  describe "#possible_moves" do
    context "with its move direction is set to up" do
      let(:position) { [6, 0] }

      context "when it's the first move" do
        it "returns two possible moves" do
          expected = [[5, 0], [4, 0]]
          result = pawn.possible_moves
          expect(result).to eq(expected)
        end
      end

      context "when it's not the first move" do
        before { pawn.instance_variable_set(:@first_move, false) }

        it "returns one possible move" do
          expected = [[5, 0]]
          result = pawn.possible_moves
          expect(result).to eq(expected)
        end
      end

      context "when it's in a position close to the top edge" do
        let(:position) { [0, 0] }
        before { pawn.instance_variable_set(:@move_direction, :up) }

        it "returns an empty array" do
          result = pawn.possible_moves
          expect(result).to be_empty
        end
      end
    end

    context "with its move direction is set to down" do
      let(:position) { [1, 0] }

      context "when it's the first move" do
        it "returns two possible moves" do
          expected = [[2, 0], [3, 0]]
          result = pawn.possible_moves
          expect(result).to eq(expected)
        end
      end

      context "when it's not the first move" do
        before { pawn.instance_variable_set(:@first_move, false) }

        it "returns one possible move" do
          expected = [[2, 0]]
          result = pawn.possible_moves
          expect(result).to eq(expected)
        end
      end

      context "when it's in a position close to the bottom edge" do
        let(:position) { [7, 0] }
        before { pawn.instance_variable_set(:@move_direction, :down) }

        it "returns an empty array" do
          result = pawn.possible_moves
          expect(result).to be_empty
        end
      end
    end
  end

  describe "#possible_captures" do
    context "when its move direction is set to up" do
      let(:position) { [6, 3] }

      context "with one piece in range" do
        before { described_class.new(board, :black, [5, 4]) }

        it "returns the position of the piece in range" do
          expected = [[5, 4]]
          result = pawn.possible_captures
          expect(result).to eq(expected)
        end
      end

      context "with two pieces in range" do
        before do
          described_class.new(board, :black, [5, 4])
          described_class.new(board, :black, [5, 2])
        end

        it "returns the positions of the pieces in range" do
          expected = [[5, 2], [5, 4]]
          result = pawn.possible_captures
          expect(result).to eq(expected)
        end
      end

      context "with an allied piece in range" do
        before { described_class.new(board, :white, [5, 4]) }

        it "returns an empty array" do
          result = pawn.possible_captures
          expect(result).to be_empty
        end
      end
    end

    context "when its move direction is set to down" do
      let(:position) { [1, 3] }

      context "with one piece in range" do
        before { described_class.new(board, :black, [2, 4]) }

        it "returns the position of the piece in range" do
          expected = [[2, 4]]
          result = pawn.possible_captures
          expect(result).to eq(expected)
        end
      end

      context "with two pieces in range" do
        before do
          described_class.new(board, :black, [2, 4])
          described_class.new(board, :black, [2, 2])
        end

        it "returns the positions of the pieces in range" do
          expected = [[2, 2], [2, 4]]
          result = pawn.possible_captures
          expect(result).to eq(expected)
        end
      end

      context "with an allied piece in range" do
        before { described_class.new(board, :white, [2, 4]) }

        it "returns an empty array" do
          result = pawn.possible_captures
          expect(result).to be_empty
        end
      end
    end
  end
end

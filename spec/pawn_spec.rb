require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/pawn"
require_relative "../lib/board"

# rubocop:disable Metrics

describe Pawn do
  subject(:pawn) { described_class.new(board, :white, position) }
  let(:position) { [6, 0] }
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:at_position)
    allow(board).to receive(:place_piece_at)
    allow(board).to receive(:move_piece)
    allow(board).to receive(:remove_piece_at)
  end

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
        before { pawn.instance_variable_set(:@move_direction, -1) }

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
        before { pawn.instance_variable_set(:@move_direction, 1) }

        it "returns an empty array" do
          result = pawn.possible_moves
          expect(result).to be_empty
        end
      end
    end
  end
end

require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces"
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

  describe "#promote?" do
    context "with the pawn in e2" do
      before { pawn.instance_variable_set(:@move_direction, :up) }
      let(:position) { [1, 4] }

      it "returns true after moving to e1" do
        expect { pawn.move([0, 4]) }.to change { pawn.promote? }.to(true)
      end
    end

    context "with the pawn in e7" do
      before { pawn.instance_variable_set(:@move_direction, :down) }
      let(:position) { [6, 4] }

      it "returns true after moving to e8" do
        expect { pawn.move([7, 4]) }.to change { pawn.promote? }.to(true)
      end
    end
  end

  describe "#promote" do
    subject(:promoting_piece) { described_class.new(board, :white, position) }

    before do
      @original_position = promoting_piece.position
      @original_side = promoting_piece.side
    end

    context "when promoting to a rook" do
      it "is really a rook" do
        promoted_piece = promoting_piece.promote(Rook)
        expect(promoted_piece).to be_a(Rook)
      end

      it "reappears in the same place, with the same attributes" do
        promoted_piece = promoting_piece.promote(Rook)
        expect(promoted_piece).to have_attributes(position: @original_position, side: @original_side)
      end
    end

    context "when promoting to a bishop" do
      it "is really a bishop" do
        promoted_piece = promoting_piece.promote(Bishop)
        expect(promoted_piece).to be_a(Bishop)
      end

      it "reappears in the same place, with the same attributes" do
        promoted_piece = promoting_piece.promote(Bishop)
        expect(promoted_piece).to have_attributes(position: @original_position, side: @original_side)
      end
    end

    context "when promoting to a knight" do
      it "is really a knight" do
        promoted_piece = promoting_piece.promote(Knight)
        expect(promoted_piece).to be_a(Knight)
      end

      it "reappears in the same place, with the same attributes" do
        promoted_piece = promoting_piece.promote(Knight)
        expect(promoted_piece).to have_attributes(position: @original_position, side: @original_side)
      end
    end

    context "when promoting to a queen" do
      it "is really a queen" do
        promoted_piece = promoting_piece.promote(Queen)
        expect(promoted_piece).to be_a(Queen)
      end

      it "reappears in the same place, with the same attributes" do
        promoted_piece = promoting_piece.promote(Queen)
        expect(promoted_piece).to have_attributes(position: @original_position, side: @original_side)
      end
    end

    context "when trying promoting to a pawn" do
      it "is the same pawn object" do
        promoted_piece = promoting_piece.promote(Pawn)
        expect(promoted_piece).to be(promoting_piece)
      end
    end

    context "when trying promoting to a king" do
      it "is the same pawn object" do
        promoted_piece = promoting_piece.promote(King)
        expect(promoted_piece).to be(promoting_piece)
      end
    end
  end
end

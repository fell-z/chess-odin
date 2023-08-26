require_relative "./piece_base_shared_spec"
require_relative "../lib/chess_pieces/king"
require_relative "../lib/chess_pieces/rook"
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

  describe "#possible_captures" do
    context "when it's in" do
      context "one of the default positions, e8" do
        let(:position) { [0, 4] }

        context "with two enemy's pieces in range, one in d7 and one in f8" do
          before do
            described_class.new(board, :black, [1, 3])
            described_class.new(board, :black, [0, 5])
          end

          it "returns the positions d7 and f8" do
            computed_captures = king.possible_captures
            valid_captures = [[1, 3], [0, 5]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end

      context "the center, in d4" do
        let(:position) { [4, 3] }

        context "with three enemy's pieces in range, one in d5, one in e3 and one in c4" do
          before do
            described_class.new(board, :black, [3, 3])
            described_class.new(board, :black, [5, 4])
            described_class.new(board, :black, [4, 2])
          end

          it "returns the positions d5, e3 and c4" do
            computed_captures = king.possible_captures
            valid_captures = [[3, 3], [5, 4], [4, 2]]
            expect(computed_captures).to include(*valid_captures)
          end
        end
      end
    end
  end

  describe "#castling" do
    context "at the eighth rank" do
      let(:position) { [0, 4] }

      context "on the kingside" do
        let!(:rook) { Rook.new(board, :white, [0, 7]) }

        it "successfully performs the castling, changing the positions of the king and rook" do
          desired_king_position = [0, 6]
          desired_rook_position = [0, 5]
          expect { king.castling(:kingside) }.to change { king.position }.to(desired_king_position)
                                             .and change { rook.position }.to(desired_rook_position)
        end

        context "with king's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end

        context "with rook's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end
      end

      context "on the queenside" do
        let!(:rook) { Rook.new(board, :white, [0, 0]) }

        it "successfully performs the castling, changing the positions of the king and rook" do
          desired_king_position = [0, 2]
          desired_rook_position = [0, 3]
          expect { king.castling(:queenside) }.to change { king.position }.to(desired_king_position)
                                              .and change { rook.position }.to(desired_rook_position)
        end

        context "with king's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end

        context "with rook's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end
      end
    end

    context "at the first rank" do
      let(:position) { [7, 4] }

      context "on the kingside" do
        let!(:rook) { Rook.new(board, :white, [7, 7]) }

        it "successfully performs the castling, changing the positions of the king and rook" do
          desired_king_position = [7, 6]
          desired_rook_position = [7, 5]
          expect { king.castling(:kingside) }.to change { king.position }.to(desired_king_position)
                                             .and change { rook.position }.to(desired_rook_position)
        end

        context "with king's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end

        context "with rook's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end
      end

      context "on the queenside" do
        let!(:rook) { Rook.new(board, :white, [7, 0]) }

        it "successfully performs the castling, changing the positions of the king and rook" do
          desired_king_position = [7, 2]
          desired_rook_position = [7, 3]
          expect { king.castling(:queenside) }.to change { king.position }.to(desired_king_position)
                                              .and change { rook.position }.to(desired_rook_position)
        end

        context "with king's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end

        context "with rook's move not being the first" do
          before { king.instance_variable_set(:@first_move, false) }

          it "fails, so it doesn't change any of the piece's positions" do
            original_king_position = king.position
            original_rook_position = rook.position
            king.castling(:kingside)
            expect([king.position, rook.position]).to eq([original_king_position, original_rook_position])
          end
        end
      end
    end
  end
end

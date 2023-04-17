shared_examples "a subclass of PieceBase" do
  context "when calling methods from the base class" do
    it "responds to #move" do
      expect(subject).to respond_to(:move)
    end

    it "responds to #capture" do
      expect(subject).to respond_to(:capture)
    end
  end
end

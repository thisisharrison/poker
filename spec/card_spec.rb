require "rspec"
require "card"

describe Card do
    describe "#initialize" do
        subject(:card) { Card.new(:spades, :ace) }

        it "sets up card correctly" do
            expect(card.suit).to eq(:spades)
            expect(card.value).to eq(:ace)
        end

        it "raise error if invalid suit" do
            expect{ Card.new(:invalid, :ten)}.to raise_error("not a valid suit")
        end

        it "raise error if invalid value" do
            expect{ Card.new(:spades, :hundred)}.to raise_error("not a valid value")
        end
    end

    describe "#<=>" do 
        it "should return 0 when cards the same" do
            expect(Card.new(:clubs, :ace)<=>Card.new(:clubs, :ace)).to eq(0)
        end

        it "should return 1 when card has higher value" do
            expect(Card.new(:clubs, :ace)<=>Card.new(:clubs, :two)).to eq(1)
        end

        it "should return 1 when card has higher suit" do
            expect(Card.new(:spades, :two)<=>Card.new(:hearts, :two)).to eq(1)
        end

        it "should return -1 when card has low value" do
            expect(Card.new(:clubs, :two)<=>Card.new(:clubs, :ace)).to eq(-1)
        end

        it "should return -1 when card has low suit" do
            expect(Card.new(:hearts, :two)<=>Card.new(:spades, :two)).to eq(-1)
        end
    end

end

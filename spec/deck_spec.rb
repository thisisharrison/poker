require "rspec"
require "deck"
require "hand"

describe Deck do
    describe "::all_cards" do
        subject(:deck) { Deck.all_cards }
        it "generates a deck of 52 cards" do
            expect(deck.count).to eq(52)
        end

        it "has no duplicates" do
            expect(deck.map { |card| card.to_s }.uniq.count).to eq(deck.count)
        end
    end

    let(:cards) do [
        double("card", :suits => :spades, :value => :king),
        double("card", :suits => :spades, :value => :queen),
        double("card", :suits => :spades, :value => :jack)
    ]
    end

    describe "#initialize" do 
        it "fills itself with 52 cards" do
            deck = Deck.new
            expect(deck.count).to eq(52)
        end

        it "can take in array of cards" do
            deck = Deck.new(cards)
            expect(deck.count).to eq(3)
        end
    end

    let(:deck) do 
        Deck.new(cards.dup)
    end

    it "should not expose cards" do
        expect(deck).not_to respond_to(:deck)
    end

    describe "#take" do 
        it "takes from the top" do
            # take first, does it take :cards first
            expect(deck.take(1)).to eq(cards[0..0])
            # after first is take, does it take after 1st card
            expect(deck.take(2)).to eq(cards[1..2])
        end

        it "takes the right amount" do
            deck.take(2)
            # one left after took 2, no need to create a #count method for deck
            expect(deck.count).to eq(1)
        end

        it "doesn't take more than what's in the deck" do
            expect{deck.take(4)}.to raise_error("not enough cards")
        end
    end

    
    describe "#return" do
        let(:return_cards) do [
            double("card", :suits => :hearts, :value => :king),
            double("card", :suits => :hearts, :value => :queen),
            double("card", :suits => :hearts, :value => :jack)
        ]
        end

        it "returns cards to deck" do
            deck.return(return_cards)
            expect(deck.count).to eq(6)
        end

        it "adds to the bottom of the deck" do 
            deck.return(return_cards)
            # toss away 3, test the remaining 3
            deck.take(3)
            expect(deck.take(1)).to eq(return_cards[0..0])
            expect(deck.take(1)).to eq(return_cards[1..1])
            expect(deck.take(1)).to eq(return_cards[2..2])
        end

        it "should not destroy passed array" do
            return_cards_dup = return_cards.dup
            deck.return(return_cards_dup)
            # does the array still exists
            expect(return_cards_dup).to eq(return_cards)
        end
    end

    describe "#shuffle" do
        it "should shuffle the cards" do 
            deck_dup = deck.dup
            shuffled = deck_dup.shuffle
            expect(shuffled).not_to eq(deck)
        end
    end

    describe "#deal_hand" do 
        let(:deck) {Deck.new}
        it "should return a hand" do
            hand = deck.deal_hand
            expect(hand).to be_a(Hand)
            expect(hand.cards.count).to eq(5)
        end

        it "should take cards from deck" do 
            expect{deck.deal_hand}.to change{deck.count}.by(-5)
            # alternative:
            # hand = deck.deal_hand
            # expect(deck.count).to eq(52-5)
        end
    end


end
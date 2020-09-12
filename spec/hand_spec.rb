require "rspec"
require "hand"
require "card"

describe Hand do
    let(:cards) {[
        Card.new(:spades, :ten),
        Card.new(:spades, :jack),
        Card.new(:spades, :queen),
        Card.new(:spades, :king),
        Card.new(:spades, :ace)
    ]}

    subject(:hand) { Hand.new(cards) }

    describe "#initialize" do
        it "accept cards reader" do
            expect(hand.cards).to match_array(cards)
            # alternative:
            # expect(hand.cards).to eq(cards)
        end

        it "raises error if not five cards" do
            expect{Hand.new(cards[0..3])}.to raise_error("not five cards")
        end
    end

    describe "#trade_cards" do
        let(:discard_cards) {hand.cards[0..1]}
        let(:return_cards) {[Card.new(:hearts, :ten), Card.new(:hearts, :jack)]}
        let(:not_own) {[Card.new(:spades, :two), Card.new(:spades, :three)]}

        it "discard cards" do
            hand.trade_cards(discard_cards, return_cards)
            expect(hand.cards).to_not include(*discard_cards)
        end

        it "takes new cards" do 
            hand.trade_cards(discard_cards, return_cards)
            expect(hand.cards).to include(*return_cards)
        end

        it "should raise error if not five cards" do
            expect{hand.trade_cards(discard_cards, return_cards[0..0])}.to raise_error("not five cards")
        end

        it "should raise error if tries to discard cards not owned" do 
            expect{hand.trade_cards(not_own, return_cards)}.to raise_error("discarding cards not owned")
        end
    end

    describe "poker hands" do
        let(:royal_flush) do 
            Hand.new([
                Card.new(:spades, :ace),
                Card.new(:spades, :king),
                Card.new(:spades, :queen),
                Card.new(:spades, :jack),
                Card.new(:spades, :ten)
            ])
        end

        let(:straight_flush) do 
            Hand.new([
                Card.new(:spades, :eight),
                Card.new(:spades, :seven),
                Card.new(:spades, :six),
                Card.new(:spades, :five),
                Card.new(:spades, :four)
            ])
        end

        let(:four_of_a_kind) do 
            Hand.new([
                Card.new(:spades, :ace),
                Card.new(:hearts, :ace),
                Card.new(:clubs, :ace),
                Card.new(:diamonds, :ace),
                Card.new(:spades, :four)
            ])
        end

        let(:full_house) do 
            Hand.new([
                Card.new(:spades, :ace),
                Card.new(:hearts, :ace),
                Card.new(:clubs, :king),
                Card.new(:diamonds, :king),
                Card.new(:spades, :king)
            ])
        end

        let(:flush) do 
            Hand.new([
                Card.new(:clubs, :two),
                Card.new(:clubs, :four),
                Card.new(:clubs, :six),
                Card.new(:clubs, :ten),
                Card.new(:clubs, :king)
            ])
        end

        let(:straight) do 
            Hand.new([
                Card.new(:clubs, :six),
                Card.new(:hearts, :five),
                Card.new(:diamonds, :four),
                Card.new(:diamonds, :three),
                Card.new(:spades, :two)
            ])
        end

        let(:three_of_a_kind) do 
            Hand.new([
                Card.new(:clubs, :queen),
                Card.new(:hearts, :queen),
                Card.new(:diamonds, :queen),
                Card.new(:diamonds, :three),
                Card.new(:spades, :two)
            ])
        end

        let(:two_pair) do 
            Hand.new([
                Card.new(:clubs, :queen),
                Card.new(:hearts, :queen),
                Card.new(:diamonds, :jack),
                Card.new(:spades, :jack),
                Card.new(:spades, :two)
            ])
        end

        let(:one_pair) do 
            Hand.new([
                Card.new(:clubs, :queen),
                Card.new(:hearts, :queen),
                Card.new(:diamonds, :jack),
                Card.new(:spades, :ten),
                Card.new(:spades, :two)
            ])
        end

        let(:high_card) do 
            Hand.new([
                Card.new(:spades, :six),
                Card.new(:hearts, :five),
                Card.new(:clubs, :jack),
                Card.new(:spades, :ten),
                Card.new(:spades, :two)
            ])
        end

        let(:ranking) do
            [
                :royal_flush,
                :straight_flush,
                :four_of_a_kind,
                :full_house,
                :flush,
                :straight,
                :three_of_a_kind,
                :two_pair,
                :one_pair,
                :high_card
            ]
        end

        # using the hands we just created
        let(:hands) do 
            [
                royal_flush,
                straight_flush,
                four_of_a_kind,
                full_house,
                flush,
                straight,
                three_of_a_kind,
                two_pair,
                one_pair,
                high_card
            ]
        end

        describe "#rank" do
            it "should return the ranking of the hand" do
                hands.each_with_index do |hand, i|
                    expect(hand.rank).to eq(ranking[i])
                end
            end

            # subclass testing for ranking functions
            context "when straight with ace" do
                let(:ace_straight) do 
                    Hand.new([
                        Card.new(:clubs, :ace),
                        Card.new(:hearts, :two),
                        Card.new(:diamonds, :three),
                        Card.new(:diamonds, :four),
                        Card.new(:spades, :five)
                    ])
                end
                it "should allow ace be low card" do
                    expect(ace_straight.rank).to eq(:straight)
                end
            end

        end

        describe "#<=>" do 
            it "returns 1 for a hand with higher rank" do
                expect(royal_flush<=>straight).to eq(1)
            end

            it "returns -1 for a hand with lower rank" do
                expect(two_pair<=>flush).to eq(-1)
            end

            it "returns 0 for identical hands" do
                expect(one_pair<=>one_pair).to eq(0)
            end

            context "when hands have the same rank (tie breaker)" do
                context "when royal flush" do
                    let(:small_royal_flush) do 
                        Hand.new([
                            Card.new(:diamonds, :ace),
                            Card.new(:diamonds, :king),
                            Card.new(:diamonds, :queen),
                            Card.new(:diamonds, :jack),
                            Card.new(:diamonds, :ten)
                        ])
                    end
                    let(:big_royal_flush) do
                        Hand.new([
                            Card.new(:spades, :ace),
                            Card.new(:spades, :king),
                            Card.new(:spades, :queen),
                            Card.new(:spades, :jack),
                            Card.new(:spades, :ten)
                        ])
                    end
                    it "compares based on suit" do
                        expect(small_royal_flush <=> big_royal_flush).to eq(-1)
                        expect(big_royal_flush <=> small_royal_flush).to eq(1)
                    end
                end

                context "when straight flush" do
                    let(:small_straight_flush) do
                        Hand.new([
                            Card.new(:diamonds, :two),
                            Card.new(:diamonds, :three),
                            Card.new(:diamonds, :four),
                            Card.new(:diamonds, :five),
                            Card.new(:diamonds, :six)
                        ])
                    end
                    let(:big_straight_flush) do
                        Hand.new([
                            Card.new(:diamonds, :three),
                            Card.new(:diamonds, :four),
                            Card.new(:diamonds, :five),
                            Card.new(:diamonds, :six),
                            Card.new(:diamonds, :seven)
                        ])
                    end
                    let(:big_suit_straight_flush) do
                        Hand.new([
                            Card.new(:hearts, :three),
                            Card.new(:hearts, :four),
                            Card.new(:hearts, :five),
                            Card.new(:hearts, :six),
                            Card.new(:hearts, :seven)
                        ])
                    end
                    it "compares based on high card" do
                        expect(small_straight_flush <=> big_straight_flush).to eq(-1)
                        expect(big_straight_flush <=> small_straight_flush).to eq(1)
                    end

                    it "compares based on suit when high card is the same" do
                        expect(big_straight_flush <=> big_suit_straight_flush).to eq(-1)
                        expect(big_suit_straight_flush <=> big_straight_flush).to eq(1)
                    end
                end

                context "when four of a kind" do
                    let(:four_ace) do
                        Hand.new([
                            Card.new(:diamonds, :ace),
                            Card.new(:hearts, :ace),
                            Card.new(:spades, :ace),
                            Card.new(:clubs, :ace),
                            Card.new(:hearts, :king)
                        ])
                    end
                    let(:mega_four_ace) do
                        Hand.new([
                            Card.new(:diamonds, :ace),
                            Card.new(:hearts, :ace),
                            Card.new(:spades, :ace),
                            Card.new(:clubs, :ace),
                            Card.new(:spades, :king)
                        ])
                    end
                    let(:small_four_ace) do
                        Hand.new([
                            Card.new(:diamonds, :ace),
                            Card.new(:hearts, :ace),
                            Card.new(:spades, :ace),
                            Card.new(:clubs, :ace),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:four_king) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:spades, :king),
                            Card.new(:clubs, :king),
                            Card.new(:hearts, :two)
                        ])
                    end
                    it "compares based on value" do
                        expect(four_ace <=> four_king).to eq(1)
                        expect(four_king <=> four_ace).to eq(-1)
                    end

                    it "compares based on high card value if same four of a kind" do
                        expect(four_ace <=> small_four_ace).to eq(1)
                        expect(small_four_ace <=> four_ace).to eq(-1)
                    end

                    it "compares based on high card suit if same high card value" do
                        expect(mega_four_ace <=> four_ace).to eq(1)
                        expect(four_ace <=> mega_four_ace).to eq(-1)
                    end
                end
                
                context "when two pair" do
                    let(:big_two_pair) do
                        Hand.new([
                            Card.new(:diamonds, :five),
                            Card.new(:hearts, :five),
                            Card.new(:spades, :four),
                            Card.new(:clubs, :four),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:small_two_pair) do
                        Hand.new([
                            Card.new(:diamonds, :three),
                            Card.new(:hearts, :three),
                            Card.new(:spades, :four),
                            Card.new(:clubs, :four),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:one_pair) do
                        Hand.new([
                            Card.new(:diamonds, :three),
                            Card.new(:hearts, :three),
                            Card.new(:spades, :four),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    it "higher of two pairs wins" do
                        expect(big_two_pair <=> small_two_pair).to eq(1)
                        expect(small_two_pair <=> big_two_pair).to eq(-1)
                    end

                    it "two pair beats one pair" do
                        expect(big_two_pair <=> one_pair).to eq(1)
                        expect(one_pair <=> big_two_pair).to eq(-1)
                    end
                end

                context "when one pair" do 
                    let(:king_pair) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:spades, :four),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:ace_pair) do
                        Hand.new([
                            Card.new(:diamonds, :ace),
                            Card.new(:hearts, :ace),
                            Card.new(:spades, :four),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:king_pair_ace_high) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:spades, :ace),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:king_pair_queen_high) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:spades, :queen),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    it "compares based on pair value" do
                        expect(ace_pair <=> king_pair).to eq(1)
                    end

                    it "compares based on high card if same pair value" do
                        expect(king_pair_ace_high <=> king_pair_queen_high).to eq(1)
                    end
                end

                context "when full house" do
                    let(:high_kings_two_jacks) do 
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:spades, :king),
                            Card.new(:clubs, :jack),
                            Card.new(:hearts, :jack)
                        ])
                    end
                    let(:low_kings_two_jacks) do 
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:clubs, :king),
                            Card.new(:clubs, :jack),
                            Card.new(:hearts, :jack)
                        ])
                    end
                    let(:low_kings_two_aces) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:clubs, :king),
                            Card.new(:clubs, :ace),
                            Card.new(:hearts, :ace)
                        ])
                    end
                    let(:bigger_low_kings_two_aces) do
                        Hand.new([
                            Card.new(:diamonds, :king),
                            Card.new(:hearts, :king),
                            Card.new(:clubs, :king),
                            Card.new(:diamonds, :ace),
                            Card.new(:hearts, :ace)
                        ])
                    end
                    
                    
                    it "compares based on set of 3" do
                        expect(high_kings_two_jacks <=> low_kings_two_jacks).to eq(1)
                    end

                    it "if set of 3 the same, it compares set of 2" do
                        expect(low_kings_two_aces <=> low_kings_two_jacks).to eq(1)
                    end

                    it "if highest of 3 and highest of 2 the same, it compares remaining highest card" do
                        expect(low_kings_two_aces <=> bigger_low_kings_two_aces).to eq(-1)
                    end
                end

                context "when high card" do
                    let(:jack_high) do
                        Hand.new([
                            Card.new(:diamonds, :jack),
                            Card.new(:hearts, :three),
                            Card.new(:spades, :eight),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    let(:ten_high) do
                        Hand.new([
                            Card.new(:diamonds, :ten),
                            Card.new(:hearts, :three),
                            Card.new(:spades, :eight),
                            Card.new(:clubs, :five),
                            Card.new(:hearts, :two)
                        ])
                    end
                    it "compares based on high card" do
                        expect(jack_high <=> ten_high).to eq(1)
                        expect(ten_high <=> jack_high).to eq(-1)
                    end
                end
            end
        end

        describe "::winner" do
            it "returns the winning hand" do 
                high_hands = [flush, straight_flush, one_pair]
                expect(Hand.winner(high_hands)).to eq(straight_flush)

                low_hands = [one_pair, two_pair, three_of_a_kind]
                expect(Hand.winner(low_hands)).to eq(three_of_a_kind)
            end
        end
    end
end


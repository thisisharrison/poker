require_relative "./card"
require_relative "./hand"

class Deck

    def self.all_cards
        deck =[]
        Card::VALUE_STRINGS.keys.each do |value|
            Card::SUIT_STRINGS.keys.each do |suit|
                deck << Card.new(suit, value)
            end
        end
        deck
    end

    def initialize(deck = Deck.all_cards)
        @deck = deck
    end

    def count
        @deck.count
    end

    def take(amount)
        raise "not enough cards" unless amount <= @deck.count 
        @deck.shift(amount)
    end

    def return(cards)
        # unbrackets the array with splat
        @deck.push(*cards)
        # iterative
        # cards.each do |card|
        #     @deck << card
        # end
    end

    def shuffle
        @deck.shuffle!
    end

    def deal_hand
        Hand.new(take(5))
    end

    private 
    attr_reader :deck
end

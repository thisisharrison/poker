require_relative "./poker_hands"


class Hand
    include PokerHands 

    attr_reader :cards
    def initialize(cards)
        raise "not five cards" unless cards.length == 5
        # Sort cards for ranking
        @cards = cards.sort
    end

    def self.winner(hands)
        # debugger
        # Ruby uses <=> by default and we didn’t have to write a separate sort method
        hands.sort.last
    end

    def trade_cards(old, new)
        raise "not five cards" unless old.count == new.count
        raise "discarding cards not owned" unless has_cards?(old)
        remove_cards(old)
        add_cards(new)
        old
    end

    def empty?
        @cards.empty?
    end

    def to_s
        cards.join(" ")
    end

    private
    def has_cards?(cards)
        cards.all? { |card| @cards.include?(card) }
    end

    def remove_cards(old)
        old.each do |card|
            idx = @cards.index(card)
            @cards.delete_at(idx)
        end
    end
    
    def add_cards(new)
        @cards.push(*new)
    end
end

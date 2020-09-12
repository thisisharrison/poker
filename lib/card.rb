class Card
    # include Comparable

    SUIT_STRINGS = {
    :clubs    => "♣",
    :diamonds => "♦",
    :hearts   => "♥",
    :spades   => "♠"
    }

    VALUE_STRINGS = {
    :two   => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"
    }

    def self.suits 
        SUIT_STRINGS.keys
    end

    def self.values
        VALUE_STRINGS.keys
    end

    def self.royal_values
        VALUE_STRINGS.keys[-5..-1]
    end

    attr_reader :suit, :value

    def initialize(suit, value)
        raise "not a valid suit" unless Card.suits.include?(suit)
        raise "not a valid value" unless Card.values.include?(value)
        @suit, @value = suit, value
    end

    def ==(other_card)
        suit == other_card.suit && value == other_card.value
    end

    def <=>(other_card)
        if self == other_card
            return 0
        elsif value != other_card.value
            return Card.values.index(value) <=> Card.values.index(other_card.value)
        elsif suit != other_card.suit
            return Card.suits.index(suit) <=> Card.suits.index(other_card.suit)
        end
    end

    def <(other_card)
        
        if self == other_card
            return false
        elsif value != other_card.value
            return Card.values.index(value) < Card.values.index(other_card.value) 
        elsif suit != other_card.suit
            return Card.suits.index(suit) < Card.suits.index(other_card.suit) 
        end
    end

    def to_s
        VALUE_STRINGS[value] + SUIT_STRINGS[suit]
    end
end

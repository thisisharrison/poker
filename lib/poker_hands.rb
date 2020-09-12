require_relative "./tie_breaker"

module PokerHands
    include TieBreaker

    RANKS = [
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


    def rank
        RANKS.each do |rank|
            # self.send(*arg) allows to invoke another method by name. Here replace name of the function with #{}
            return rank if self.send("#{rank}?")
        end
    end
    
    def <=>(other_hand)
        if self == other_hand
            0
        elsif self.rank != other_hand.rank
            other_idx = RANKS.reverse.index(other_hand.rank)
            idx = RANKS.reverse.index(rank)
            idx <=> other_idx
        else
            tie_breaker(other_hand)
        end
    end

    def has_a?(suit_or_value)
        @cards.any? do |card|
            card.suit == suit_or_value || card.value == suit_or_value
        end
    end

    def card_value_count(value)
        @cards.map(&:value).count(value)
    end

    def royal? 
        Card.royal_values.all?{ |value| @cards.map(&:value).include?(value) }
    end

    def royal_flush?
        royal? && straight_flush?
    end

    def straight_flush?
        straight? && flush?
    end

    def flush? 
        @cards.map(&:suit).uniq.length == 1
    end

    def straight?
        if has_a?(:ace) && has_a?(:two)
            # process ace as 1
            # :two, :three, :four, :five + :ace
            straight = Card.values[0..3] + [:ace]
        else
            low_idx = Card.values.index(@cards.first.value)
            straight = Card.values[low_idx..(low_idx + 4)]
        end
        @cards.map(&:value) == straight
    end

    def four_of_a_kind?
        @cards.any? { |card| card_value_count(card.value) == 4 }
    end

    def full_house?
        three_of_a_kind? && one_pair?
    end

    def three_of_a_kind?
        @cards.any? { |card| card_value_count(card.value) == 3 }
    end

    def two_pair?
        pairs.count == 2
    end

    def one_pair?
        pairs.count == 1
    end

    def high_card?
        true
    end

    def pairs
        # get all pairs in hand 
        pairs = []
        # the unique value in the hand
        @cards.map(&:value).uniq.each do |value|
            # confirm this value is a pair
            if card_value_count(value) == 2
                pairs << @cards.select { |card| card.value == value }
            end
        end
        pairs
    end
end

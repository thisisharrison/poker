require "byebug"

module TieBreaker
    def tie_breaker(other_hand)
        case rank
        when :royal_flush, :straight_flush, :straight, :flush, :high_card
            high_card <=> other_hand.high_card
        when :four_of_a_kind
            compare_set_then_high_card(4, other_hand)
        when :three_of_a_kind
            compare_set_then_high_card(3, other_hand)
        when :full_house
            compare_full_house(other_hand)
        when :two_pair
            compare_two_pair(other_hand)
        when :one_pair
            compare_set_then_high_card(2, other_hand)
        end
    end

    # for those than order matters: 
    # no matter what rank, the highest card defines the winner
    # card already has a #<=> to compare suits and values
    def high_card
        @cards.sort.last
    end

    def highest_in_set(n)
        @cards.select { |card| card_value_count(card.value) == n }.sort.last
    end

    def cards_without(value)
        @cards.select { |card| card.value != value }
    end

    def compare_set_then_high_card(n, other_hand)
        # get the highest card in the set
        card, other_card = highest_in_set(n), other_hand.highest_in_set(n)
        # if two cards are the same, compare the high card
        if card == other_card
            cards_without(card.value).last <=> other_hand.cards_without(other_card.value).last
        else
            card <=> other_card
        end
    end

    def compare_full_house(other_hand)
        threes = highest_in_set(3) <=> other_hand.highest_in_set(3)
        if threes == 0
            twos = highest_in_set(2) <=> other_hand.highest_in_set(2)
            if twos == 0
                three_tie = full_house_tie(other_hand, 2)
                if three_tie == 0
                    two_tie = full_house_tie(other_hand, 3)
                    two_tie
                else
                    three_tie
                end
            else
                twos
            end
        else
            threes
        end
    end

    def full_house_tie(other_hand, n)
        n_cards = cards_without(highest_in_set(n).value).sort.reverse
        other_n_cards = other_hand.cards_without(highest_in_set(n).value).sort.reverse
        len = n_cards.length - 1
        (0..len).each do |i|
            compare = n_cards[i] <=> other_n_cards[i]
            return compare if compare != 0
        end
        0
    end

    def compare_two_pair(other_hand)
        high = high_pair[0] <=> other_hand.high_pair[0]
        if high == 0
            low = low_pair[0] <=> other_hand.low_pair[0]
            if low == 0
                # find next highest card and compare
                high_card = @cards.find do |card|
                    card_value_count(card.value) != 2
                end
                other_high_card = @cards.find do |card|
                    other_hand.card_value_count(card.value) != 2
                end
                high_card <=> other_high_card
            else
                low
            end
        else
            high
        end
    end

    def high_pair
        # maximum 2 pairs of diff value per 5 cards 
        # return highest pair
        # compare first card of each pair and return bigger pair
        if pairs[1][0] < pairs[0][0]
            pairs[0]
        else
            pairs[1]
        end
    end

    def low_pair
        # return lowest pair
        if pairs[0][0] < pairs[1][0]
            pairs[0]
        else
            pairs[1]
        end
    end

    def pairs
        pairs = []
        @cards.map(&:value).uniq.each do |value|
            if card_value_count(value) == 2
                pairs << @cards.select { |card| card.value == value }
            end
        end
        puts pairs
        pairs
    end
end

class Player
    attr_reader :bankroll, :hand, :current_bet

    def self.buy_in(bankroll)
        Player.new(bankroll)
    end

    def initialize(bankroll)
        @bankroll = bankroll
        @current_bet = 0
    end

    def deal_in(hand)
        @hand = hand
    end

    def take_bet(total_bet)
        # take raise into account 
        # bet 10 raise to 20, betting only extra 10
        amount = total_bet - current_bet
        raise "not enough $" unless amount <= bankroll
        @current_bet = total_bet
        @bankroll -= amount
        amount 
    end

    def receive_winnings(amount)
        @bankroll += amount 
    end

    def return_cards
        cards = hand.cards
        @hand = nil
        cards 
    end

    def fold
        @folded = true
    end

    def folded?
        @folded
    end

    def unfold
        @folded = false
    end

    def trade_cards(old_cards, new_cards)
        hand.trade_cards(old_cards, new_cards)
    end

    def get_cards_to_trade
        print "Cards to trade? (ex. '1, 4, 5') > "
        card_idx = gets.chomp.split(",").map(&:strip).map(&:to_i)
        raise "Cannot trade more than 3 cards" unless card_idx.count <= 3
        # create array of cards
        card_idx.map { |i| hand.cards[i - 1]}
    end

    def get_bet
        print "Bet (You have: #{bankroll}) >"
        bet = gets.chomp.to_i
        raise "not enough $" unless bet <= bankroll
        bet
    end

    def respond_bet
        print "(c)all, (b)et, or (f)old? > "
        response = gets.chomp.downcase[0]
        case response 
        when "c" then :call
        when "b" then :bet
        when "f" then :fold
        else
            puts "must be c, b, or f"
            respond_bet
        end
    end

    def reset_current_bet
        @current_bet = 0
    end

    def <=>(other_player)
        hand <=> other_player.hand
    end
end

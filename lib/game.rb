require_relative "./player"
require_relative "./deck"

class Game
    attr_reader :pot, :deck, :players
    def initialize
        @pot = 0
        @players = []
        @deck = Deck.new
    end

    # def deck
    #     @deck = Deck.new
    # end

    def add_players(n, buy_in)
        n.times { 
            @players << Player.buy_in(buy_in)
        }
    end

    def game_over?
        players.count { |player| player.bankroll > 0 } <= 1
    end

    def round_over?
        # 1 left unfold
        players.count { |player| !player.folded? } <= 1
    end

    def deal_cards
        players.each do |player|
            next unless player.bankroll > 0
            player.deal_in(deck.deal_hand)
        end
    end

    def add_to_pot(amount)
        @pot += amount
        amount
    end

    def play
        play_round until game_over?
        end_game
    end

    def end_game
        print "Game over"
    end

    def play_round
        deck.shuffle
        reset_players
        deal_cards
        take_bets
        trade_cards
        take_bets
        end_round
    end

    def reset_players
        # reset fold status
        players.each(&:unfold)
    end

    def take_bets
        players.each(&:reset_current_bet)
        high_bet = 0
        no_raises = false
        most_recent_bet = nil

        until no_raises
            no_raises = true
            players.each_with_index do |player, i|
                next if player.folded? || player.bankroll <= 0
                break if most_recent_bet == player || round_over?
                
                display_status(i, high_bet)
                
                begin
                    response = player.respond_bet
                    case response
                    when :call
                        add_to_pot(player.take_bet(high_bet))
                        sleep(1)
                        system("clear")
                    when :bet
                        raise "not enough money" unless player.bankroll >= high_bet
                        no_raise = false
                        most_recent_bet = player
                        bet = player.get_bet
                        raise "bet must be at least $#{high_bet}" unless bet >= high_bet
                        r = player.take_bet(bet)
                        high_bet = bet 
                        add_to_pot(r)
                        sleep(1)
                        system("clear")
                    when :fold
                        player.fold
                        sleep(1)
                        system("clear")
                    end
                rescue => error
                    puts "#{error.message}"
                    sleep(1)
                    system("clear")
                    retry
                end
            end
        end
    end

    def trade_cards
        players.each_with_index do |player, i|
            next if player.folded? || player.hand.empty?
            print "Player #{i + 1}, which cards do you want to trade: "
            puts player.hand.to_s
            cards = player.get_cards_to_trade
            deck.return(cards)
            player.trade_cards(cards, deck.take(cards.count))
            sleep(1)
            system("clear")
        end
    end

    def end_round
        show_hands
        puts "WINNER"
        puts "#{winner.hand.to_s} wins $#{pot} with a #{winner.hand.rank}"
        winner.receive_winnings(pot)
        @pot = 0
        return_cards
        sleep(2)
        system("clear")
    end

    def show_hands
        puts "HANDS"
        players.each do |player|
            next if player.folded?
            puts "#{player.hand.to_s} (#{player.hand.rank})"
        end
    end

    def winner
        # max will use <=> in player
        players.max
    end

    def return_cards
        players.each { |player| @deck.return(player.return_cards) }
    end

    def display_status(index, high_bet)
        puts "Pot $#{@pot}"
        puts "High bet: $#{high_bet}"

        players.each_with_index do |player, i|
            puts "Player #{i+1} has $#{player.bankroll}"
        end

        puts "Current player: #{index + 1}"
        puts "Player #{index + 1} has bet: $#{players[index].current_bet}"
        puts "The bet is at $#{high_bet}"
        puts "Player #{index + 1}'s hand: #{players[index].hand.to_s}"
    end
end

def start
    g = Game.new
    g.add_players(2, 100)
    g.play
end

if __FILE__ == $PROGRAM_NAME
    start
end
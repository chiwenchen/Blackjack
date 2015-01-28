require 'pry'
# s: 黑桃 h: 紅心 d: 方塊 c: 梅花

# initial table
# basic variables:
# 1.all cards
# 2. players  cards and total value
# 3. dealers  cards and total value

# 1. Welcome message
# 2. start game
#   2.1 initial the game by giving player 2 cards by random, both face up
#   2.2 dealer send 2 cards to itself, 1 face up, another face down.
# loop
# 3 player can choose to stay(only avialible when your cards added up between 17 ~ 21) or hit
#   3.1 if stay, stop getting cards, and start compare a value
#   3.2 if hit, gets another card
# 4 game over if player busted
# 5 dealer hit until above 17
#  5.1 hit until 17, check if win?
#  5.1 hit until above players sum up or busted 

# end
# 5 compare the value
# 6 announce winner 

cards = [1,2,3,4,5,6,7,8,9,10,"J","Q","K"]
suits = ['Heart-', 'Spades-', 'Diamonds-', 'Clubs-']
all_cards = suits.product(cards)
player_cards = []
dealer_cards = []
covered_card = dealer_cards[1]
uncover = false #dealer's 2nd card's condition
#can use delete or delete_at to remove the card which is picked.


def initial_game(all_cards, player_cards, dealer_cards)
  get_card(all_cards, player_cards)
  get_card(all_cards, player_cards)
  get_card(all_cards, dealer_cards)
  get_card(all_cards, dealer_cards)
end

def show_table(all_cards, player_cards, dealer_cards, uncover)
  system 'clear'
  #-------------show dealer's cards------------
  # print "      "
  # dealer_cards.count.times do
  #   print "#{"---- "} "
  # end
  puts " "
  print "Dealer's cards: "
  dealer_cards.each do |card|
    if dealer_cards.index(card) != 1 || (dealer_cards.index(card) == 1 && uncover == true)
    print "[#{card.join}] "
    else
    print "[coverd]" 
    end
  end
  print " Dealer has #{sum_up(dealer_cards)} points" if uncover == true
  puts " "
#-------------show player's cards---------------
  puts " "
  print "Player's cards: "
  player_cards.each do |card|
    print "[#{card.join}] "
  end
  print "  You get #{sum_up(player_cards)} points" 
  puts " "
  puts " "
end

def get_card(all_cards, owner_cards)
  player_get = all_cards.index(all_cards.sample)
  owner_cards << all_cards[player_get] 
  all_cards.delete_at(player_get)
end

def player_choice(all_cards, player_cards, dealer_cards, uncover)
  begin
    puts "You wanna Stay or Hit. S)Stay H)Hit"
    player_choice = gets.chomp.upcase
  end until player_choice == "H" || player_choice == "S"
  if player_choice == "H"
    get_card(all_cards, player_cards)
    show_table(all_cards, player_cards, dealer_cards, uncover)
  elsif player_choice == "S"
    return "Stay"
  end
  nil
end

def sum_up(all_cards)
  value_of_cards = all_cards.map{|a|a[1].class == String ? a[1] = 10 : a[1]}
  sum = value_of_cards.inject(:+)
  (sum <= 11 && value_of_cards.include?(1))? sum += 10 : sum #this will return your cards value
end

def dealer_round(all_cards, player_cards, dealer_cards, uncover)
  sum = sum_up(dealer_cards)
  if sum < sum_up(player_cards)
    get_card(all_cards, dealer_cards)
    sleep 1.5
  end
end

#------------Main Program-------------
begin
  system 'clear'
  puts "Welcome to Blackjack!"
  initial_game(all_cards, player_cards, dealer_cards)
  show_table(all_cards, player_cards, dealer_cards, uncover)
  begin
    stop_player_round = player_choice(all_cards, player_cards, dealer_cards, uncover)
    sum = sum_up(player_cards)
    if sum > 21
      stop_player_round = "Busted!!"
    end
    if sum == 21
      puts "You hit blackjack!!"
      break
    end
  end until stop_player_round

  if stop_player_round == "Busted!!"
    puts "You #{stop_player_round}"
  else
    uncover = true
    begin
     dealer_round(all_cards, player_cards, dealer_cards, uncover)
     show_table(all_cards, player_cards, dealer_cards, uncover)
    end until sum_up(dealer_cards)  >= 17 

    if sum_up(dealer_cards) > 21 || sum_up(dealer_cards) < sum_up(player_cards)
      puts "Player win!!"
    elsif sum_up(dealer_cards) == sum_up(player_cards)
      puts "It's a Tie!"
    else
      puts "Dealer Win!!"
    end
  end 

  puts "Wanna play again? Y) Yes"
  play_again = gets.chomp.upcase
  if play_again == "Y"
    all_cards = all_cards + player_cards + dealer_cards
    player_cards = []
    dealer_cards = []
    uncover = false
  else 
    puts "Good Bye~"
  end
end while play_again == "Y"


























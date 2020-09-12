# Poker
Using TDD to write a poker game, specifically five card draw.

## Learning Goals
* Be able to define desired functionality, write specs, and then implement
* Know how to follow red, green, refactor TDD workflow
* Know how to create and use test doubles
* Know when to use context and describe

## Rules
* Each player is dealt five cards.
* Players bet; each player may fold, see the current bet, or raise.
* In turn, each player can choose to discard up to three cards.
* They are dealt new cards from the deck to replace their old cards.
* Players bet again.
* If any players do not fold, then players reveal their hands; strongest hand wins the pot.

## Design
Classes you will want:
* Card
* Deck
* Hand
    * The logic of calculating pair, three-of-a-kind, two-pair, etc. goes here.
    * Logic of which hand beats which would go here.
* Player
    * Each player has a hand, plus a pot
    * Player has methods to ask the user:
    * Which cards they wish to discard
    * Whether they wish to fold, see, or raise.
* Game
    * Holds the deck
    * Keeps track of whose turn it is
    * Keeps track of the amount in the pot.
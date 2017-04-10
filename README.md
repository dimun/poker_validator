# PokerValidator (Work in progess)

Elixir validator for Texas Holdem hands, with a given list of cards it returns the best possible hand with a given score

## Getting started

    $ git clone https://github.com/dimun/poker_validator.git
    $ cd poker_validator
    $ mix compile
    $ iex -S mix

## Examples
  The poker validator `hand` method receives a list of Cards
  The suit for a card must be 1(spade), 2(diamond), 3(club), 4(heart).
  A value must be 2, 3, 4, 5, 6, 7, 8, 9, 10, 11(J), 12(Q), 13(K), 14(A).

  This is a straight flush of spades
  ```Elixir
    iex>alias PokerValidator.Card
    iex> cards = [
      %Card{suit: 1 value: 10},
      %Card{suit: 1, value: 11},
      %Card{suit: 1, value: 12},
      %Card{suit: 1, value: 13},
      %Card{suit: 3, value: 6},
      %Card{suit: 4, value: 8},
      %Card{suit: 1, value: 14}
    ]
    ...
    iex> PokerValidator.hand(cards)
    %PokerValidator.Hand{cards: [%PokerValidator.Card{suit: 1, value: 10},
     %PokerValidator.Card{suit: 1, value: 11},
     %PokerValidator.Card{suit: 1, value: 12},
     %PokerValidator.Card{suit: 1, value: 13},
     %PokerValidator.Card{suit: 1, value: 14}],
     highs: [14], score: 10000000, suit: 1, value: :royal_straight_flush}
  ```

## LICENSE

poker_validator is licensed under MIT License

defmodule PokerValidatorTest do
  use ExUnit.Case
  alias PokerValidator
  alias PokerValidator.Card
  alias PokerValidator.Hand

  test "royal straight flush" do
    suit = 1
    cards = [
      %Card{suit: suit, value: 10},
      %Card{suit: suit, value: 11},
      %Card{suit: suit, value: 12},
      %Card{suit: suit, value: 13},
      %Card{suit: 3, value: 6},
      %Card{suit: 4, value: 8},
      %Card{suit: suit, value: 14}
    ]
    result = PokerValidator.hand(cards)
    IO.inspect result
    assert result.suit == suit
    assert result.value == :royal_straight_flush
    assert result.highs == [14]
  end

  test "straight flush, high card 5" do
    suit = 1
    cards = [
      %Card{suit: suit, value: 2},
      %Card{suit: suit, value: 3},
      %Card{suit: suit, value: 4},
      %Card{suit: suit, value: 5},
      %Card{suit: 3, value: 6},
      %Card{suit: 4, value: 8},
      %Card{suit: suit, value: 14}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == suit
    assert result.value == :straight_flush
    assert result.highs == [5]
  end

  test "straight flush, high card 6" do
    suit = 4
    cards = [
      %Card{suit: suit, value: 2},
      %Card{suit: suit, value: 3},
      %Card{suit: suit, value: 4},
      %Card{suit: suit, value: 5},
      %Card{suit: 3, value: 6},
      %Card{suit: suit, value: 14},
      %Card{suit: suit, value: 6}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == suit
    assert result.value == :straight_flush
    assert result.highs == [6]
  end

  test "flush, high card 12" do
    suit = 4
    cards = [
      %Card{suit: suit, value: 2},
      %Card{suit: suit, value: 3},
      %Card{suit: suit, value: 4},
      %Card{suit: suit, value: 12},
      %Card{suit: 3, value: 6},
      %Card{suit: 2, value: 14},
      %Card{suit: suit, value: 6}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == suit
    assert result.value == :flush
    assert result.highs == [12]
  end


end

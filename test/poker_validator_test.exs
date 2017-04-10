defmodule PokerValidatorTest do
  use ExUnit.Case
  alias PokerValidator
  alias PokerValidator.Card

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

  test "poker of 10, high 12" do
    value = 10
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 11},
      %Card{suit: 3, value: value},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 9},
      %Card{suit: 3, value: 12}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :poker
    assert result.highs == [10, 12]
  end

  test "poker of 12, high 10" do
    value = 12
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 7},
      %Card{suit: 3, value: value},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 9},
      %Card{suit: 3, value: 10}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :poker
    assert result.highs == [12, 10]
  end

  test "full house of aces(14) and 9" do
    value = 14
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 9},
      %Card{suit: 3, value: 2},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 9},
      %Card{suit: 4, value: 9}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :full_house
    assert result.highs == [14, 9]
  end

  test "full house of 9 and aces(14)" do
    value = 9
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 14},
      %Card{suit: 3, value: 2},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 14},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :full_house
    assert result.highs == [9, 14]
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

  test "straight, high card 5" do
    cards = [
      %Card{suit: 1, value: 2},
      %Card{suit: 2, value: 3},
      %Card{suit: 1, value: 4},
      %Card{suit: 4, value: 5},
      %Card{suit: 3, value: 9},
      %Card{suit: 4, value: 8},
      %Card{suit: 3, value: 14}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :straight
    assert result.highs == [5]
  end

  test "straight, high card 6" do
    cards = [
      %Card{suit: 1, value: 2},
      %Card{suit: 2, value: 3},
      %Card{suit: 3, value: 4},
      %Card{suit: 4, value: 5},
      %Card{suit: 3, value: 6},
      %Card{suit: 4, value: 14},
      %Card{suit: 2, value: 6}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :straight
    assert result.highs == [6]
  end

  test "set of 7, with A(14) and Q(12)" do
    value = 7
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 14},
      %Card{suit: 3, value: 2},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 12},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :set
    assert result.highs == [7, 14, 12]
  end

  test "set of Q(12), with A(14) and 7" do
    value = 12
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 14},
      %Card{suit: 3, value: 2},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 7},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :set
    assert result.highs == [12, 14, 7]
  end

  test "set of A(14), with Q(12) and 7" do
    value = 14
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 12},
      %Card{suit: 3, value: 2},
      %Card{suit: 4, value: value},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 7},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :set
    assert result.highs == [14, 12, 7]
  end

  test "two pairs of A(14) and Q(12), high K(13)" do
    value1 = 14
    value2 = 12
    cards = [
      %Card{suit: 1, value: value1},
      %Card{suit: 3, value: value2},
      %Card{suit: 3, value: 5},
      %Card{suit: 4, value: value1},
      %Card{suit: 2, value: value2},
      %Card{suit: 1, value: 13},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :two_pairs
    assert result.highs == [14, 12, 13]
  end

  test "two pairs of A(14) and 2, high 9" do
    value1 = 14
    value2 = 2
    cards = [
      %Card{suit: 1, value: value1},
      %Card{suit: 3, value: value2},
      %Card{suit: 3, value: 4},
      %Card{suit: 4, value: value1},
      %Card{suit: 2, value: value2},
      %Card{suit: 1, value: 9},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :two_pairs
    assert result.highs == [14, 2, 9]
  end

  test "a pair of Q(12), highs 14, 13, 11" do
    value = 12
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 13},
      %Card{suit: 3, value: 4},
      %Card{suit: 4, value: 14},
      %Card{suit: 2, value: value},
      %Card{suit: 1, value: 11},
      %Card{suit: 4, value: 5}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :pair
    assert result.highs == [12, 14, 13, 11]
  end

  test "high cards A(14), 9,8,7,6" do
    value = 14
    cards = [
      %Card{suit: 1, value: value},
      %Card{suit: 3, value: 9},
      %Card{suit: 3, value: 8},
      %Card{suit: 4, value: 7},
      %Card{suit: 2, value: 6},
      %Card{suit: 1, value: 3},
      %Card{suit: 4, value: 2}
    ]
    result = PokerValidator.hand(cards)
    assert result.suit == nil
    assert result.value == :high_card
    assert result.highs == [14, 9, 8, 7, 6]
  end


end

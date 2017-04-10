defmodule PokerValidator do
  @moduledoc """
  This is the main module for validating the hands.
  """
  alias PokerValidator.Combination
  alias PokerValidator.Hand
  alias PokerValidator.Card

  @doc """
  With a given list of cards (Greater or equal than 5), this function evaluates
  the best possible hand, it returns a Hand:
  """
  def hand(cards) when is_list(cards) and length(cards) >= 5 do
    combinations = Combination.combinations(cards, 5)
    Enum.reduce(combinations, nil, fn(comb, best_hand) ->
      hand = comb
      |> Enum.sort(&(&1.value < &2.value))
      |> get_hand
     if is_nil(best_hand) || hand.score > best_hand.score,
      do: hand, else: best_hand
    end)
  end

  # Straight flush or flush
  defp get_hand([
    %Card{value: value1, suit: suit},
    %Card{value: value2, suit: suit},
    %Card{value: value3, suit: suit},
    %Card{value: value4, suit: suit},
    %Card{value: value5, suit: suit}] = cards) do
    values = [value1, value2, value3, value4, value5]
    case {is_straight?(values), value1, value5} do
      {true, 10, _} ->
        Hand.new_hand(:royal_straight_flush, cards,
          %{highs: [value5], suit: suit})
      {true, 2, 14} ->
        Hand.new_hand(:straight_flush, cards, %{highs: [5], suit: suit})
      {true, _, _} ->
        Hand.new_hand(:straight_flush, cards, %{highs: [value5], suit: suit})
      {false, _, _} ->
        Hand.new_hand(:flush, cards, %{highs: [value5], suit: suit})
    end
  end

  # Poker
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _}] = cards) do
    Hand.new_hand(:poker, cards, %{highs: [value1, value2]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _}] = cards) do
    Hand.new_hand(:poker, cards, %{highs: [value2, value1]})
  end

  # Full house
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _}] = cards) do
    Hand.new_hand(:full_house, cards, %{highs: [value1, value2]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _}] = cards) do
    Hand.new_hand(:full_house, cards, %{highs: [value2, value1]})
  end

  # set
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:set, cards, %{highs: [value1, value3, value2]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:set, cards, %{highs: [value2, value3, value1]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:set, cards, %{highs: [value3, value2, value1]})
  end

  # two pairs
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:two_pairs, cards, %{highs: [value2, value1, value3]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:two_pairs, cards, %{highs: [value3, value2, value1]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value3, suit: _}] = cards) do
    Hand.new_hand(:two_pairs, cards, %{highs: [value3, value1, value2]})
  end

  # pair
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value4, suit: _}] = cards) do
    Hand.new_hand(:pair, cards, %{highs: [value1, value4, value3, value2]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value4, suit: _}] = cards) do
    Hand.new_hand(:pair, cards, %{highs: [value2, value4, value3, value1]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value4, suit: _}] = cards) do
    Hand.new_hand(:pair, cards, %{highs: [value3, value4, value2, value1]})
  end
  defp get_hand([
    %Card{value: value1, suit: _},
    %Card{value: value2, suit: _},
    %Card{value: value3, suit: _},
    %Card{value: value4, suit: _},
    %Card{value: value4, suit: _}] = cards) do
    Hand.new_hand(:pair, cards, %{highs: [value4, value3, value2, value1]})
  end

  # Stright or high card
  defp get_hand(cards) do
    values = cards |> Enum.map(&(&1.value))
    case {is_straight?(values), values} do
      {true, [2, _, _, _, 14]} ->
        Hand.new_hand(:straight, cards, %{highs: [5]})
      {true, [_, _, _, _, value5]} ->
        Hand.new_hand(:straight, cards, %{highs: [value5]})
      _ ->
        Hand.new_hand(:high_card, cards, %{highs: values |> Enum.reverse})
    end
  end

  # Verifies if a list of 5 cards is a straight
  defp is_straight?([2,3,4,5,14]), do: true
  defp is_straight?(values) do
    [h | t] = values
    {is_straight?, _} = Enum.reduce_while(t, {true, h},
      fn(value, {_straight?, prev_value}) ->
        if value == prev_value + 1,
          do: {:cont, {true, value}},
        else: {:halt, {false, value}}
      end
    )
    is_straight?
  end
end

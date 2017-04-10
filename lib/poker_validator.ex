defmodule PokerValidator do
  @moduledoc """
  Documentation for PokerValidator.
  """
  alias PokerValidator.Combination
  alias PokerValidator.Hand
  alias PokerValidator.Card

  @doc """
  With a given list of cards (Greater or equal than 5), this function evaluates
  the best possible hand, it returns a Hand Struct that contains:
    * `value` - atom with the name of the hand. the available values are:
    ...-`:royal_straight_flush`
    ...-`:straight_flush`
    ...-`:poker`
    ...-`:full_house`
    ...-`:flush`
    ...-`:straight`
    ...-`:set`
    ...-`:two_pairs`
    ...-`:pair`
    ...-`:high_card`
    * `score` - integer with the given score, this score can be used for compare
      hands
    * `cards` - chosen cards for the hand
    * `highs` - contains the values used for qualifying the hand
    * `suit` - only used for flush hands
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

  defp get_hand(cards) do
    hihgs = cards |> Enum.map(&(&1.value)) |> Enum.reverse
    Hand.new_hand(:high_card, cards, %{highs: hihgs})
  end

  # Verifies if a list of 5 cards is a straight
  defp is_straight?([2,3,4,5,14]), do: true
  defp is_straight?(values) do
    [h | t] = values
    {is_straight?, _} = Enum.reduce_while(t, {true, h},
      fn(value, {straight?, prev_value}) ->
        if value == prev_value + 1,
          do: {:cont, {true, value}},
        else: {:halt, {false, value}}
      end
    )
    is_straight?
  end
end

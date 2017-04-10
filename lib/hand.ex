defmodule PokerValidator.Hand do
  defstruct value: nil, score: 0, cards: [], highs: [], suit: nil
  @moduledoc """
  Hand is used for saving a qualification, a hand contains:
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
  @default_high 10000

  @doc """
  Gets a hand with its score
  """
  def new_hand(value, cards, reference \\ %{}) do
    %__MODULE__{
      value: value,
      score: get_score(value, reference),
      cards: cards,
      highs: Map.get(reference, :highs),
      suit: Map.get(reference, :suit)
    }
  end

  defp get_score(value, reference) do
    base_score = Map.get(scores(), value)
    {score, _} = case value do
      :royal_straight_flush -> {base_score, nil}
      _value -> Enum.reduce(reference.highs, {base_score, @default_high},
        fn(high, {score, divisor}) ->
          {score + (high * divisor), divisor / 10}
        end)
    end
    score
  end

  defp scores do
    %{
      royal_straight_flush: 10000000,
      straight_flush: 9000000,
      poker: 8000000,
      full_house: 7000000,
      flush: 6000000,
      straight: 5000000,
      set: 4000000,
      two_pairs: 3000000,
      pair: 2000000,
      high_card: 1000000
    }
  end
end

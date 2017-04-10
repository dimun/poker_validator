defmodule PokerValidator.Combination do
@moduledoc """
Code taken from Comb library.
[Comb](https://github.com/tallakt/comb)
"""

  @doc """
  Returns any combination of the elements in `enum` with exactly `k` elements.
  Repeated elements are handled intelligently.
  ## Examples
      iex> combinations([1, 2, 3], 2) |> Enum.to_list
      [[1, 2], [1, 3], [2, 3]]
      iex> combinations([1, 1, 2], 2) |> Enum.to_list
      [[1, 1], [1, 2]]
  """
  @spec combinations(Enum.t, integer) :: Enum.t
  def combinations(enum, k) do
    List.last(do_combinations(enum, k))
    |> Enum.uniq
  end

  defp do_combinations(enum, k) do
   combinations_by_length = [[[]]|List.duplicate([], k)]
   list = Enum.to_list(enum)
   List.foldr list, combinations_by_length, fn x, next ->
     sub = :lists.droplast(next)
     step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
     :lists.zipwith(&:lists.append/2, step, next)
   end
  end
end

defmodule ArtistMatch do
  @doc """
  Takes a list of items
  Returns a list of 2-tuples that represent all 2-item combinations of that list
  Each 2-tuple is sorted by default sort order
  """
  def generate_permutations(items) when is_list(items) do
    items
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {item1, idx} ->
      remaining_items = Enum.drop(items, idx)

      remaining_items
      |> Enum.map(fn item2 ->
        sort_tuple([item1, item2])
      end)
    end)
  end

  defp sort_tuple(items) do
    [first, second] = Enum.sort(items)
    {first, second}
  end
end

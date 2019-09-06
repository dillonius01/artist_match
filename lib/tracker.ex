defmodule ArtistMatch.Tracker do
  @doc """
  We also track a result_set so that we need not iterate through the accumulation later
  """
  defstruct accumulated: %{},
            result_set: [],
            threshold: 0

  @doc """
  Takes an ordered 2-tuple artist match and a tracker accumulation
  Accounts for the match and returns an updated tracker
  """
  def track_single_match(
        {artist1, artist2} = match,
        %__MODULE__{
          accumulated: accumulated,
          result_set: result_set,
          threshold: threshold
        } = tracker
      ) do
    # not ideal but we can assume no commas in either artist name
    key = "#{artist1},#{artist2}"

    new_total = get_new_total(accumulated, key)

    new_accumulated =
      accumulated
      |> Map.put(key, new_total)

    new_result_set = add_if_threshold_hit(result_set, new_total, threshold, match)

    %{tracker | accumulated: new_accumulated, result_set: new_result_set}
  end

  @doc """
  Takes a list of ordered 2-tuple matches and a tracker struct.
  Accumulates the new matches and returns the updated tracker.
  """
  def track_list_of_matches(matches, tracker) when is_list(matches) do
    matches
    |> Enum.reduce(tracker, fn match, inner_tracker ->
      track_single_match(match, inner_tracker)
    end)
  end

  @doc """
  Receives a list of comma-separated artists and a tracker struct
  Returns a `%ArtistMatch.Tracker{}` with all matches accounted for
  """
  def find_and_track_all_matches(artist_list, initial_tracker) do
    artist_list
    |> Enum.reduce(initial_tracker, fn line, tracker ->
      line
      |> split_and_clean_line()
      |> ArtistMatch.generate_permutations()
      |> track_list_of_matches(tracker)
    end)
  end

  defp split_and_clean_line(line) do
    line
    |> String.trim()
    |> String.split(",")
  end

  defp get_new_total(accumulated, key) do
    case Map.get(accumulated, key) do
      nil -> 1
      some -> some + 1
    end
  end

  # append to front of list for Elixir performance reasons
  defp add_if_threshold_hit(result_set, new_total, threshold, match)
       when new_total == threshold do
    [match | result_set]
  end

  defp add_if_threshold_hit(result_set, _new_total, _threshold, _match) do
    result_set
  end
end

defmodule ArtistMatch.Formatter do
  alias ArtistMatch.Tracker

  @doc """
  Receives a tracker object and returns a csv of the `result_set`
  """
  def format_result_set_as_csv(%Tracker{result_set: result_set}) do
    result_set
    |> Enum.map(fn {artist1, artist2} ->
      "#{artist1},#{artist2}"
    end)
    |> Enum.join("\n")
  end
end

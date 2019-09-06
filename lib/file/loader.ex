defmodule ArtistMatch.File.Loader do
  alias ArtistMatch.Tracker

  @doc """
  Reads from the `input_file` set in the configuration
  Returns a `%ArtistMatch.Tracker{}` struct with all the found matches
  """
  def process_input_file() do
    initial_tracker = %Tracker{
      threshold: Application.get_env(:artist_match, :threshold)
    }

    input_file = Application.get_env(:artist_match, :input_file)

    input_file
    |> File.stream!()
    |> Tracker.find_and_track_all_matches(initial_tracker)
  end
end

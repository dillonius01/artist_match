defmodule ArtistMatch.File.Writer do
  alias ArtistMatch.Tracker
  alias ArtistMatch.Formatter

  @doc """
  Takes `output_content` string and writes to the output_file set via configuration
  """
  def write_to_output_file(output_content) do
    output_path = Application.get_env(:artist_match, :output_file)

    File.write(output_path, output_content)
  end

  @doc """
  Transforms the `result_set` from the `tracker` argument into csv
  Writes the csv to the output file per `write_to_output_file/1`
  """
  def format_as_csv_and_write_to_file(%Tracker{} = tracker) do
    tracker
    |> Formatter.format_result_set_as_csv()
    |> write_to_output_file()
  end
end

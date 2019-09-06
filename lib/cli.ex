defmodule ArtistMatch.CLI do
  alias ArtistMatch.File.Writer
  alias ArtistMatch.File.Loader

  def main(_args) do
    IO.puts("Welcome to ArtistMatch!")
    IO.puts("Processing input file...")
    t1 = DateTime.utc_now()

    populated_tracker = Loader.process_input_file()

    t2 = DateTime.utc_now()
    diff = DateTime.diff(t2, t1)

    IO.puts("Finished finding matches in #{diff} seconds")
    IO.puts("Writing to output file...")

    Writer.format_as_csv_and_write_to_file(populated_tracker)

    IO.puts("All done!")
  end
end

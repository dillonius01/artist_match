defmodule ArtistMatch.FormatterTest do
  use ExUnit.Case

  test "format_result_set_as_csv/1 joins result_set into csv" do
    result_set = [{"CRJ", "Wu-Tang"}, {"NWA", "Robyn"}]
    tracker = %ArtistMatch.Tracker{result_set: result_set}
    expected = "CRJ,Wu-Tang\nNWA,Robyn"

    actual = ArtistMatch.Formatter.format_result_set_as_csv(tracker)

    assert expected == actual
  end
end

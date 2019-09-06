defmodule ArtistMatchTest do
  use ExUnit.Case

  describe "generate_permutations/1" do
    test "returns a list of tuples" do
      input = ["Radiohead", "Allman Brothers Band", "Wu-Tang Clan", "Robyn"]

      expected = [
        {"Allman Brothers Band", "Radiohead"},
        {"Allman Brothers Band", "Robyn"},
        {"Allman Brothers Band", "Wu-Tang Clan"},
        {"Radiohead", "Robyn"},
        {"Radiohead", "Wu-Tang Clan"},
        {"Robyn", "Wu-Tang Clan"}
      ]

      actual = ArtistMatch.generate_permutations(input) |> Enum.sort()

      assert expected == actual
    end
  end
end

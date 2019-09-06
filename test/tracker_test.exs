defmodule ArtistMatch.TrackerTest do
  use ExUnit.Case
  alias ArtistMatch.Tracker

  describe "track_single_match/2" do
    test "appends pair to empty accumulation" do
      match = {"Robyn", "Van Halen"}
      accumulated = %{}

      expected = %{
        "Robyn,Van Halen" => 1
      }

      actual =
        Tracker.track_single_match(match, %Tracker{
          accumulated: accumulated,
          threshold: 10
        })

      assert expected == actual.accumulated
    end

    test "increments if accumulation not empty" do
      match = {"Robyn", "Van Halen"}
      accumulated = %{"Robyn,Van Halen" => 1}

      expected = %{
        "Robyn,Van Halen" => 2
      }

      actual =
        Tracker.track_single_match(match, %Tracker{
          accumulated: accumulated,
          threshold: 10
        })

      assert expected == actual.accumulated
    end

    test "does not lose existing accumulations" do
      match = {"Robyn", "Van Halen"}
      accumulated = %{"Robyn,Van Halen" => 8, "Bob Dylan,NWA" => 5}

      expected = %{
        "Robyn,Van Halen" => 9,
        "Bob Dylan,NWA" => 5
      }

      actual =
        Tracker.track_single_match(match, %Tracker{
          accumulated: accumulated,
          threshold: 10
        })

      assert expected == actual.accumulated
    end

    test "adds a match to the result set if it hits the threshold" do
      match = {"Robyn", "Van Halen"}
      accumulated = %{"Robyn,Van Halen" => 9, "Bob Dylan,NWA" => 5}

      expected = [{"Robyn", "Van Halen"}]

      actual =
        Tracker.track_single_match(match, %Tracker{
          accumulated: accumulated,
          threshold: 10
        })

      assert expected == actual.result_set
    end

    test "does not add duplicates to the result set" do
      match = {"Robyn", "Van Halen"}
      accumulated = %{"Robyn,Van Halen" => 11, "Bob Dylan,NWA" => 5}

      expected = [{"Robyn", "Van Halen"}]

      actual =
        Tracker.track_single_match(match, %Tracker{
          result_set: [{"Robyn", "Van Halen"}],
          accumulated: accumulated,
          threshold: 10
        })

      assert expected == actual.result_set
    end
  end

  describe "track_list_of_matches/2" do
    test "accumulates each pair in accumulated" do
      matches = [
        {"Allman Brothers Band", "Radiohead"},
        {"Allman Brothers Band", "Robyn"},
        {"Allman Brothers Band", "Wu-Tang Clan"},
        {"Radiohead", "Robyn"},
        {"Radiohead", "Wu-Tang Clan"},
        {"Robyn", "Wu-Tang Clan"}
      ]

      expected = %{
        "Allman Brothers Band,Radiohead" => 1,
        "Allman Brothers Band,Robyn" => 1,
        "Allman Brothers Band,Wu-Tang Clan" => 1,
        "Radiohead,Robyn" => 1,
        "Radiohead,Wu-Tang Clan" => 1,
        "Robyn,Wu-Tang Clan" => 1
      }

      actual = Tracker.track_list_of_matches(matches, %Tracker{threshold: 10})

      assert expected == actual.accumulated
    end

    test "increments pairs that have already been found" do
      matches = [
        {"Allman Brothers Band", "Radiohead"},
        {"Allman Brothers Band", "Robyn"},
        {"Allman Brothers Band", "Wu-Tang Clan"},
        {"Radiohead", "Robyn"},
        {"Radiohead", "Wu-Tang Clan"},
        {"Robyn", "Wu-Tang Clan"}
      ]

      initial = %Tracker{
        threshold: 10,
        accumulated: %{
          "Allman Brothers Band,Robyn" => 6,
          "Radiohead,Wu-Tang Clan" => 2
        }
      }

      expected = %{
        "Allman Brothers Band,Radiohead" => 1,
        "Allman Brothers Band,Robyn" => 7,
        "Allman Brothers Band,Wu-Tang Clan" => 1,
        "Radiohead,Robyn" => 1,
        "Radiohead,Wu-Tang Clan" => 3,
        "Robyn,Wu-Tang Clan" => 1
      }

      actual = Tracker.track_list_of_matches(matches, initial)

      assert expected == actual.accumulated
    end

    test "appends pair to result_set if threshold met" do
      matches = [
        {"Allman Brothers Band", "Radiohead"},
        {"Allman Brothers Band", "Robyn"},
        {"Allman Brothers Band", "Wu-Tang Clan"},
        {"Radiohead", "Robyn"},
        {"Radiohead", "Wu-Tang Clan"},
        {"Robyn", "Wu-Tang Clan"}
      ]

      initial = %Tracker{
        threshold: 7,
        accumulated: %{
          "Allman Brothers Band,Robyn" => 6,
          "Radiohead,Wu-Tang Clan" => 2
        }
      }

      expected = [{"Allman Brothers Band", "Robyn"}]

      actual = Tracker.track_list_of_matches(matches, initial)

      assert expected == actual.result_set
    end

    test "does not lose existing result_set data" do
      matches = [
        {"Allman Brothers Band", "Radiohead"},
        {"Allman Brothers Band", "Robyn"},
        {"Allman Brothers Band", "Wu-Tang Clan"},
        {"Radiohead", "Robyn"},
        {"Radiohead", "Wu-Tang Clan"},
        {"Robyn", "Wu-Tang Clan"}
      ]

      initial = %Tracker{
        threshold: 7,
        accumulated: %{
          "Allman Brothers Band,Robyn" => 6,
          "Radiohead,Wu-Tang Clan" => 20
        },
        result_set: [{"Radiohead", "Wu-Tang Clan"}]
      }

      expected = [{"Allman Brothers Band", "Robyn"}, {"Radiohead", "Wu-Tang Clan"}]

      actual = Tracker.track_list_of_matches(matches, initial)

      assert expected == actual.result_set
    end
  end

  describe "find_and_track_all_matches/2" do
    test "accumulates matches and result set as expected" do
      artists = [
        "Robyn,CRJ,Radiohead\n",
        "Wu-Tang,Robyn,CRJ,Nirvana\n",
        "Nirvana,Wu-Tang,Bob Dylan"
      ]

      initial_tracker = %Tracker{threshold: 2}

      expected = %Tracker{
        threshold: 2,
        result_set: [{"Nirvana", "Wu-Tang"}, {"CRJ", "Robyn"}],
        accumulated: %{
          "CRJ,Robyn" => 2,
          "CRJ,Radiohead" => 1,
          "Radiohead,Robyn" => 1,
          "CRJ,Nirvana" => 1,
          "CRJ,Wu-Tang" => 1,
          "Robyn,Wu-Tang" => 1,
          "Nirvana,Robyn" => 1,
          "Nirvana,Wu-Tang" => 2,
          "Bob Dylan,Nirvana" => 1,
          "Bob Dylan,Wu-Tang" => 1
        }
      }

      actual = Tracker.find_and_track_all_matches(artists, initial_tracker)

      assert expected == actual
    end
  end
end

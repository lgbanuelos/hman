defmodule Hman.LogicTest do
  use ExUnit.Case
  alias Hman.Logic

  test "Works with 'hangman' and one correct letter" do
    assert {_, "h", "", 9} = Logic.score_guess({"hangman", "", "", 9}, "h")
    assert {_, "a", "", 9} = Logic.score_guess({"hangman", "", "", 9}, "a")
    assert {_, "n", "", 9} = Logic.score_guess({"hangman", "", "", 9}, "n")
    assert {_, "g", "", 9} = Logic.score_guess({"hangman", "", "", 9}, "g")
    assert {_, "m", "", 9} = Logic.score_guess({"hangman", "", "", 9}, "m")
  end

  # @tag :skip
  test "Works with 'hangman' and two correct letters" do
    assert {_, "ha", "", 9} = {"hangman", "", "", 9} |> Logic.score_guess("h") |> Logic.score_guess("a")
    assert {_, "ng", "", 9} = {"hangman", "", "", 9} |> Logic.score_guess("n") |> Logic.score_guess("g")
    assert {_, "ah", "", 9} = {"hangman", "", "", 9} |> Logic.score_guess("a") |> Logic.score_guess("h")
  end

  # @tag :skip
  test "Works with 'hangman' and three correct letters" do
    Enum.map(1..5, fn _ ->
      seq = Enum.take_random(~w[h a n g m], 3)
      corr = Enum.join(seq)
      assert {_, ^corr, "", 9} = Enum.reduce(seq, {"hangman", "", "", 9}, fn letter, acc -> Logic.score_guess(acc, letter) end)
    end)
  end

  # @tag :skip
  test "Works with 'hangman'; correct and incorrect letters" do
    assert {_, "ha", "x", 8} = {"hangman", "", "", 9} |> Logic.score_guess("h") |> Logic.score_guess("a") |> Logic.score_guess("x")
    assert {_, "ng", "w", 8} = {"hangman", "", "", 9} |> Logic.score_guess("n") |> Logic.score_guess("w") |> Logic.score_guess("g")
    assert {_, "ah", "y", 8} = {"hangman", "", "", 9} |> Logic.score_guess("y") |> Logic.score_guess("a") |> Logic.score_guess("h")
  end

  # @tag :skip
  test "Works with 'hangman'; correct, incorrect and duplicate letters" do
    assert {_, "ha", "x", 8} = {"hangman", "", "", 9} |> Logic.score_guess("h") |> Logic.score_guess("a") |> Logic.score_guess("x") |> Logic.score_guess("h")
    assert {_, "ng", "w", 8} = {"hangman", "", "", 9} |> Logic.score_guess("n") |> Logic.score_guess("w") |> Logic.score_guess("w") |> Logic.score_guess("g")
    assert {_, "ah", "y", 8} = {"hangman", "", "", 9} |> Logic.score_guess("y") |> Logic.score_guess("a") |> Logic.score_guess("h") |> Logic.score_guess("a")
  end

  # @tag :skip
  test "Works with 'hangman' and handles end of game" do
    assert {"hangman", "", "bcdefijkl", 0} = {"hangman", "", "bcdefijkl", 0} |> Logic.score_guess("h")
    assert {"hangman", "a", "bcefijkl", 0} = {"hangman", "a", "bcefijkl", 0} |> Logic.score_guess("n") |> Logic.score_guess("w")
    assert {"hangman", "ahgn", "bcdef", 0} = {"hangman", "ahgn", "bcdef", 0} |> Logic.score_guess("y")
  end

  # @tag :skip
  test "Formats feedback" do
    assert "hang-an" == Logic.format_feedback({"hangman", "ahgn", "bcdef", 0})
    assert "--i-tst--e" == Logic.format_feedback({"flintstone", "etis", "bc", 4})
    assert "f-i-tsto-e" == Logic.format_feedback({"flintstone", "etisof", "bc", 2})
    assert "-------" == Logic.format_feedback({"hangman", "", "bcdefijkl", 0})
  end
end

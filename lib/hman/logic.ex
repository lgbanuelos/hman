defmodule Hman.Logic do
  def score_guess({_secret, _correct, _wrong, 0} = game, _guess), do: game
  def score_guess({secret, correct, wrong, turns} = game, guess) do
    cond do
      (secret =~ guess and correct =~ guess) or wrong =~ guess -> game
      secret =~ guess -> {secret, correct <> guess, wrong, turns}
      true -> {secret, correct, wrong <> guess, turns - 1}
    end
  end

  def format_feedback({secret, correct, _wrong, _turns}) do
    secret
    |> String.graphemes()
    |> Enum.map(fn l -> if correct =~ l, do: l, else: "-" end)
    |> Enum.join()
  end
end

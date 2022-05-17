defmodule Hman.Game do
  use GenServer
  alias Hman.Logic

  def start_link(name \\ :name) do
    word = Dictionary.random_word() |> String.trim()
    GenServer.start_link(__MODULE__, word, name: name)
  end

  def init(word), do: {:ok, {word, "", "", 9}}

  def submit_guess(pid, guess), do: GenServer.cast(pid, {:submit_guess, guess})
  def get_feedback(pid), do: GenServer.call(pid, :get_feedback)

  def handle_cast({:submit_guess, letter}, state) do
    {:noreply, Logic.score_guess(state, letter)}
  end

  def handle_call(:get_feedback, _from, state) do
    {:reply, {elem(state,3), Logic.format_feedback(state)}, state}
  end
end

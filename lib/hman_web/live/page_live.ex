defmodule HmanWeb.PageLive do
  use HmanWeb, :live_view

  @parts [:gallows, :head, :body, :rightArm, :leftArm, :rightLeg, :rightFoot, :leftLeg, :leftFoot]

  def mount(_params, _session, socket ) do
    {:ok, assign(socket, :feedback, "") |> assign(:turns, 9)}
  end

  def render(assigns) do
    Phoenix.View.render(HmanWeb.PageView, "index.html", assign(assigns, :parts, Enum.take(@parts, 9 - assigns.turns)))
  end

  def handle_event("new-game-req", _value, socket) do
    {:ok, game} = Hman.Game.start_link(UUID.uuid1() |> String.to_atom)
    {_turns, feedback} = Hman.Game.get_feedback(game)
    {:noreply, socket |> assign(:game, game) |> assign(:feedback, feedback) |> assign(:turns, 9)}
  end

  def handle_event(event, _value, socket) do
    IO.inspect(event)
    Hman.Game.submit_guess(socket.assigns.game, event)
    {turns, feedback} = Hman.Game.get_feedback(socket.assigns.game)
    {:noreply, socket |> assign(:feedback, feedback) |> assign(:turns, turns)}
  end

end

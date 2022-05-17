defmodule HmanWeb.PageLive do
  use HmanWeb, :live_view
  alias Hman.Game

  @parts [:gallows, :head, :body, :rightArm, :leftArm, :rightLeg, :rightFoot, :leftLeg, :leftFoot]

  def mount(_params, _session, socket ) do
    {:ok, assign(socket, :process, nil) |> assign(:feedback, "") |> assign(:turns, 9)}
  end

  def render(assigns) do
    Phoenix.View.render(HmanWeb.PageView, "index.html", assign(assigns, :parts, Enum.take(@parts, 9 - assigns.turns)))
  end

  def handle_event("new-game-req", _value, socket) do
    if socket.assigns.process != nil do
      Process.exit(socket.assigns.process, :normal)
    end
    {:ok, game} = Game.start_link(UUID.uuid1() |> String.to_atom)
    {turns, feedback} = Game.get_feedback(game)
    {:noreply, socket |> assign(:process, game) |> assign(:feedback, feedback) |> assign(:turns, turns)}
  end

  def handle_event(event, _value, socket) do
    IO.inspect(event)
    # IO.inspect(socket)
    game = socket.assigns.process
    if game != nil do
      Game.submit_guess(game, event)
      {turns, feedback} = Game.get_feedback(game)
      {:noreply, socket |> assign(:feedback, feedback) |> assign(:turns, turns)}
    else
      {:noreply, socket}
    end
  end

end

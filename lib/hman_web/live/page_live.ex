defmodule HmanWeb.PageLive do
  use HmanWeb, :live_view

  @parts [:gallows, :head, :body, :rightArm, :leftArm, :rightLeg, :rightFoot, :leftLeg, :leftFoot]

  def mount(_params, _session, socket ) do
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(HmanWeb.PageView, "index.html", assign(assigns, :parts, []))
  end

  def handle_event(event, _value, socket) do
    IO.inspect(event)
    {:noreply, socket}
  end

end

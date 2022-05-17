defmodule HmanWeb.PageController do
  use HmanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule KubeProjWeb.PageController do
  use KubeProjWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

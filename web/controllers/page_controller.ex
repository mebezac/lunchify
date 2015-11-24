defmodule Lunchify.PageController do
  use Lunchify.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

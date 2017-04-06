defmodule ElmPhoenix.Web.PageController do
  use ElmPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

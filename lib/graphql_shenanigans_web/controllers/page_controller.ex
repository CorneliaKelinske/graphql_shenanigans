defmodule GraphqlShenanigansWeb.PageController do
  use GraphqlShenanigansWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

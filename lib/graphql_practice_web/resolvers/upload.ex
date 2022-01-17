defmodule GraphqlPracticeWeb.Resolvers.Upload do
  alias GraphqlPractice.Content

  def uploads(_, _, _) do
    {:ok, Content.list_uploads()}
  end

  def get_upload(_, %{id: id}, _) do
    {:ok, Content.get_upload!(id)}
  end

  def get_upload_by_title(_, %{title: title}, _) do
    IO.puts("HIT")
    {:ok, Content.get_upload_by_title(title)}
  end
end

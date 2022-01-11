defmodule GraphqlPracticeWeb.Resolvers.Upload do
  alias GraphqlPractice.Content

  def uploads(_,_,_) do
    {:ok, Content.list_uploads}
  end

  def get_upload(_, %{id: id}, _) do
    {:ok, Content.get_upload!(id)}
  end
end

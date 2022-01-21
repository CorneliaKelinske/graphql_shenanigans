defmodule GraphqlPracticeWeb.Resolvers.Upload do
  alias GraphqlPractice.Content

  def uploads(_, _, _) do
    {:ok, Content.list_uploads()}
  end

  def get_upload(_, %{id: id}, _) do
    {:ok, Content.get_upload!(id)}
  end

  def get_upload_by_title(_, %{title: title}, _) do
    {:ok, Content.get_upload_by_title(title)}
  end

  def create_upload(_, params, _) do
    case Content.create_upload(params) do
      {:error, changeset} ->
        {:error,
         message: "Could not create upload!",
         details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)}

      {:ok, upload} ->
        {:ok, %{upload: upload}}
    end
  end

  def update_upload(_, %{id: id} = params, _) do
    id = String.to_integer(id)
    params = Map.delete(params, :id)
    with {:ok, upload} <- Content.get_upload(id),
    {:ok, updated_upload} <- Content.update_upload(upload, params) do
      {:ok, %{upload: updated_upload}}
    else
      {:error, changeset} ->
        {:error,
         message: "Could not update upload!",
         details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)}
      nil -> {:error, message: "upload not found"}



    end
  end
end

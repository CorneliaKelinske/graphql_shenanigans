defmodule GraphqlShenanigansWeb.Resolvers.Upload do
  alias GraphqlShenanigans.Content
  alias GraphqlShenanigans.Content.Upload

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
    Content.create_upload(params)
  end

  def update_upload(_, %{id: id} = params, _) do
    params = Map.delete(params, :id)

    with %Upload{} = upload <- Content.get_upload(id),
         {:ok, updated_upload} <- Content.update_upload(upload, params) do
      {:ok, updated_upload}
    else
      {:error, changeset} -> {:error, changeset}
      nil -> {:error, message: "Upload not found!"}
    end
  end

  def delete_upload(_, %{id: id}, _) do
    with %Upload{} = upload <- Content.get_upload(id),
         {:ok, deleted_upload} <- Content.delete_upload(upload) do
      {:ok, deleted_upload}
    else
      {:error, changeset} -> {:error, changeset}
      nil -> {:error, message: "Upload not found!"}
    end
  end
end

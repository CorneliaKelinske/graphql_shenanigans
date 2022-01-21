defmodule GraphqlPractice.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias GraphqlPractice.Repo

  alias GraphqlPractice.Content.Upload

  def list_uploads do
    Repo.all(Upload)
  end

  def get_upload!(id) do
    Repo.get!(Upload, id)
  end

  def get_upload(id) do
    Repo.get(Upload, id)
  end

  def get_upload_by_title(title) do
    Repo.get_by(Upload, title: title)
  end

  @spec create_upload(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_upload(attrs \\ %{}) do
    %Upload{}
    |> Upload.changeset(attrs)
    |> Repo.insert()
  end

  def update_upload(%Upload{} = upload, attrs) do
    upload
    |> Upload.changeset(attrs)
    |> Repo.update()
  end

  def delete_upload(%Upload{} = upload) do
    Repo.delete(upload)
  end

  def change_upload(%Upload{} = upload, attrs \\ %{}) do
    Upload.changeset(upload, attrs)
  end
end

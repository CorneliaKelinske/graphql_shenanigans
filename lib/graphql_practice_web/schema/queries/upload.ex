defmodule GraphqlPracticeWeb.Schema.Queries.Upload do
  use Absinthe.Schema.Notation
  alias GraphqlPractice.Content

  object :upload_queries do
    @desc "Provides a list of all uploads"
    field :uploads, list_of(:upload) do
      resolve fn _, _, _ ->
        {:ok, Content.list_uploads()}
      end
    end

    @desc "Gets an upload by id"
    field :upload, :upload do
      arg(:id, non_null(:id))

      resolve fn _, %{id: id}, _ ->
        {:ok, Content.get_upload!(id)}
      end
    end
  end
end

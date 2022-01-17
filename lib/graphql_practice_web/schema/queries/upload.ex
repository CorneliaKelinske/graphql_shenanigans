defmodule GraphqlPracticeWeb.Schema.Queries.Upload do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :upload_queries do
    @desc "Provides a list of all uploads"
    field :uploads, list_of(:upload) do
      resolve &Resolvers.Upload.uploads/3
    end

    @desc "Gets an upload by id"
    field :upload, :upload do
      arg(:id, non_null(:id))
      resolve &Resolvers.Upload.get_upload/3
    end

    @desc "Gets an upload by its title"
    field :upload_by_title, :upload do
      arg(:title, non_null(:string))
      resolve &Resolvers.Upload.get_upload_by_title/3
    end

  end
end

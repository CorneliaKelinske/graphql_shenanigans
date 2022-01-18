defmodule GraphqlPracticeWeb.Schema.Mutations.Upload do
  use Absinthe.Schema.Notation
  alias GraphqlPracticeWeb.Resolvers

  object :upload_mutations do
    @desc "Creates an upload"
    field :create_upload, :upload_result do
      arg :input, non_null(:upload_input)
      resolve(&Resolvers.Upload.create_upload/3)

    end

  end
end

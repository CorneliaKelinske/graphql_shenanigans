defmodule GraphqlPracticeWeb.Types.Error do
  use Absinthe.Schema.Notation

  @desc "Ecto changeset errors from an input"
  object :input_error do
    field :key, :string
    field :message, :string
    field :details, :string
  end
end

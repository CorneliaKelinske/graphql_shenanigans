defmodule GraphqlPractice.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    has_many :uploads, GraphqlPractice.Content.Upload

    timestamps()
  end

  @required_attrs [:name, :email]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end

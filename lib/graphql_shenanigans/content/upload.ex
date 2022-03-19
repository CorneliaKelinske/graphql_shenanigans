defmodule GraphqlShenanigans.Content.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :description, :string
    field :title, :string

    belongs_to :user, GraphqlShenanigans.Accounts.User

    timestamps()
  end

  @required_attrs [:title, :description, :user_id]

  @doc false
  def changeset(upload, attrs) do
    upload
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
  end
end

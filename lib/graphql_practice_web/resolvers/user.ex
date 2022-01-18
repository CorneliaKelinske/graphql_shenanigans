defmodule GraphqlPracticeWeb.Resolvers.User do
  alias GraphqlPractice.Accounts

  def users(_, _, _) do
    {:ok, Accounts.list_users()}
  end

  def get_user(_, %{id: id}, _) do
    {:ok, Accounts.get_user!(id)} |> IO.inspect(label: "9", limit: :infinity, charlists: false)
  end

  def get_user_by_name(_, %{name: name}, _) do
    {:ok, Accounts.get_user_by_name(name)}
  end

  def create_user(_, %{input: params}, _) do
    case Accounts.create_user(params) do
      {:error, changeset} ->
        {:error,
         message: "Could not create user!",
         details: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)}

      {:ok, user} ->
        {:ok, %{user: user}}|> IO.inspect(label: "24", limit: :infinity, charlists: false)
    end
  end
end

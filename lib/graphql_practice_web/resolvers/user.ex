defmodule GraphqlPracticeWeb.Resolvers.User do
  alias GraphqlPractice.Accounts

    def users(_, _, _) do
      {:ok, Accounts.list_users()}
    end

    def get_user(_, %{id: id}, _) do
      {:ok, Accounts.get_user!(id)}
    end


end

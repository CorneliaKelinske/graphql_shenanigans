defmodule GraphqlShenanigans.Repo do
  use Ecto.Repo,
    otp_app: :graphql_shenanigans,
    adapter: Ecto.Adapters.Postgres
end

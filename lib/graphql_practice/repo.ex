defmodule GraphqlPractice.Repo do
  use Ecto.Repo,
    otp_app: :graphql_practice,
    adapter: Ecto.Adapters.Postgres
end

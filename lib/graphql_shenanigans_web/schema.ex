defmodule GraphqlShenanigansWeb.Schema do
  use Absinthe.Schema
  alias GraphqlShenanigansWeb.Middlewares.HandleChangesetErrors

  import_types(GraphqlShenanigansWeb.Types.Metric)
  import_types(GraphqlShenanigansWeb.Types.User)
  import_types(GraphqlShenanigansWeb.Types.Upload)
  import_types(GraphqlShenanigansWeb.Schema.Queries.Metric)
  import_types(GraphqlShenanigansWeb.Schema.Queries.Upload)
  import_types(GraphqlShenanigansWeb.Schema.Queries.User)
  import_types(GraphqlShenanigansWeb.Schema.Mutations.User)
  import_types(GraphqlShenanigansWeb.Schema.Mutations.Upload)

  query do
    import_fields(:upload_queries)
    import_fields(:user_queries)
    import_fields(:metric_query)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:upload_mutations)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlShenanigans.Repo)

    Dataloader.new()
    |> Dataloader.add_source(GraphqlShenanigans.Content, source)
    |> Dataloader.add_source(GraphqlShenanigans.Accounts, source)
    |> then(&Map.put(ctx, :loader, &1))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # if it's a field for the mutation object, add this middleware to the end
  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [HandleChangesetErrors]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware
end

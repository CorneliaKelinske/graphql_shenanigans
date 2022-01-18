defmodule GraphqlPracticeWeb.Schema do
  use Absinthe.Schema
  import_types(GraphqlPracticeWeb.Types.User)
  import_types(GraphqlPracticeWeb.Types.Upload)
  import_types(GraphqlPracticeWeb.Types.Error)
  import_types(GraphqlPracticeWeb.Schema.Queries.Upload)
  import_types(GraphqlPracticeWeb.Schema.Queries.User)
  import_types(GraphqlPracticeWeb.Schema.Mutations.User)
  import_types(GraphqlPracticeWeb.Schema.Mutations.Upload)

  query do
    import_fields(:upload_queries)
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:upload_mutations)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlPractice.Repo)

    Dataloader.new()
    |> Dataloader.add_source(GraphqlPractice.Content, source)
    |> Dataloader.add_source(GraphqlPractice.Accounts, source)
    |> then(&Map.put(ctx, :loader, &1))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end

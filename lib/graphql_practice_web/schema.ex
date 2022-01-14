defmodule GraphqlPracticeWeb.Schema do
  use Absinthe.Schema
  import_types(GraphqlPracticeWeb.Types.User)
  import_types(GraphqlPracticeWeb.Types.Upload)
  import_types(GraphqlPracticeWeb.Schema.Queries.Upload)
  import_types(GraphqlPracticeWeb.Schema.Queries.User)

  query do
    import_fields(:upload_queries)
    import_fields(:user_queries)
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlPractice.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlPractice.Content, source)
    Map.put(ctx, :loader, dataloader)
  end

  # def context2(ctx) do
  #   source = Dataloader.Ecto.new(GraphqlPractice.Repo)
  #   dataloader = Dataloader.add_source(Dataloader.new(), GraphqlPractice.Accounts, source)
  #   Map.put(ctx, :loader, dataloader)
  # end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end

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
end

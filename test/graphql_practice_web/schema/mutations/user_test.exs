defmodule GraphqlPracticeWeb.Schema.Mutations.UserTest do
  use GraphqlPractice.DataCase, async: true

  alias GraphqlPracticeWeb.Schema
  alias GraphqlPractice.Accounts
  alias GraphqlPractice.Accounts.User

  @create_user_doc """
   mutation CreateUser($name: String!, $email: String!){
     createUser(name: $name, email: $email){
     errors{
       details
       key
       message
     }
     user{
      id
      email
      name
      uploads {
        title
      }
     }
   }
  }
  """

  describe "@create_user" do
    test "Creates a new user" do
      create_name = "Rand"
      create_email = "rand@darkside.com"

      assert {:ok, %{data: data}} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{"name" => create_name, "email" => create_email}
               )

      assert %{"createUser" => %{"errors" => nil, "user" => user}} = data

      assert %{
               "name" => ^create_name,
               "email" => ^create_email
             } = user

      string_id = Map.get(user, "id")
      id = String.to_integer(string_id)

      assert %User{name: ^create_name, email: ^create_email, id: ^id} = Accounts.get_user!(id)
    end

    test "Returns errors when invalid input arguments are provided" do
      create_name = ""
      create_email = ""

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{"name" => create_name, "email" => create_email}
               )

      assert [
               %{
                 details: %{name: ["can't be blank"], email: ["can't be blank"]},
                 locations: _,
                 message: "Could not create user!",
                 path: ["createUser"]
               }
             ] = errors
    end
  end
end

defmodule GraphqlPracticeWeb.Schema.Mutations.UserTest do
  use GraphqlPractice.DataCase, async: true
  import GraphqlPractice.AccountsFixtures
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
               %{message: "email: can't be blank", path: ["createUser"]},
               %{message: "name: can't be blank", path: ["createUser"]}
             ] = errors
    end
  end

  @update_user_doc """
   mutation UpdateUser($id: ID!, $name: String, $email: String){
     updateUser(id: $id, name: $name, email: $email){
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

  describe "@update_user" do
    setup [:user]

    test "Updates a user when valid params are provided", %{user: user} do
      update_name = "updated name"
      updated_email = "updated_email"
      id = user.id

      assert {:ok, %{data: data}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"name" => update_name, "email" => updated_email, "id" => id}
               )

      assert %{"updateUser" => %{"errors" => nil, "user" => user}} = data

      assert %{"name" => ^update_name, "email" => ^updated_email} = user
    end

    test "Returns errors when ID is not found", %{user: user} do
      update_name = "updated name"
      updated_email = "updated_email"
      non_existent_id = user.id + 1

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{
                   "name" => update_name,
                   "email" => updated_email,
                   "id" => non_existent_id
                 }
               )

      assert [%{message: "User not found!", path: ["updateUser"]}] = errors
    end
  end

  @delete_user_doc """
   mutation deleteUser($id: ID!){
     deleteUser(id: $id){
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

  describe "@delete_user" do
    setup [:user]

    test "Deletes a user when valid id is provided", %{user: user} do
      id = user.id

      assert {:ok, %{data: data}} =
               Absinthe.run(@delete_user_doc, Schema, variables: %{"id" => id})

      string_id = to_string(id)

      assert %{
               "deleteUser" => %{
                 "errors" => nil,
                 "user" => %{"email" => "some email", "id" => ^string_id, "name" => "some name"}
               }
             } = data

      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(id) end
    end
  end
end

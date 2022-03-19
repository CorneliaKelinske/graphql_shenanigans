defmodule GraphqlShenanigansWeb.Schema.Mutations.UserTest do
  use GraphqlShenanigans.DataCase, async: true
  import GraphqlShenanigans.AccountsFixtures
  alias GraphqlShenanigansWeb.Schema
  alias GraphqlShenanigans.Accounts
  alias GraphqlShenanigans.Accounts.User

  @create_user_doc """
   mutation CreateUser($name: String!, $email: String!){
     createUser(name: $name, email: $email){
      id
      email
      name
      uploads{
        title
      }

   }
  }
  """

  describe "@create_user" do

    setup do
      start_supervised!({GraphqlShenanigans.Metric, self()})
      :ok
    end

    test "Creates a new user" do
      create_name = "Rand"
      create_email = "rand@darkside.com"

      assert {:ok, %{data: data}} =
               Absinthe.run(@create_user_doc, Schema,
                 variables: %{"name" => create_name, "email" => create_email}
               )

      assert %{"createUser" => user} = data

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
      id
      email
      name
      uploads {
        title
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

      assert %{"updateUser" => user} = data

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
      id
      email
      name
      uploads {
        title
      }
   }
  }
  """

  describe "@delete_user" do
    setup [:user]

    test "Deletes a user when valid id is provided", %{user: %{id: user_id, name: name, email: email} = user} do
      id = user.id

      assert {:ok, %{data: data}} =
               Absinthe.run(@delete_user_doc, Schema, variables: %{"id" => id})

      string_id = to_string(id)

      assert %{"deleteUser" => deleted_user} = data
      assert %{"email" => ^email, "id" => ^string_id, "name" => ^name} = deleted_user

      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(id) end
    end
  end
end

defmodule GraphqlPracticeWeb.Schema.Queries.UserTest do
  use GraphqlPractice.DataCase, async: true
  alias GraphqlPractice.Accounts
  alias GraphqlPracticeWeb.Schema

  @user1_params %{name: "Ursula", email: "ursuala@example.com"}
  @user2_params %{name: "Birgitta", email: "birgitta@example.com"}
  @user3_params %{name: "Harry", email: "harry@example.com"}

  @user_doc """
    query getUser($id: ID){
      user(id: $id){
        id,
        name,
        email,
        uploads {
          title
        }
      }
    }
  """

  describe "@user" do
    test "Can get user by ID" do
      assert {:ok, user1} = Accounts.create_user(@user1_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_doc, Schema, variables: %{"id" => user1.id})

      assert %{"user" => %{"email" => "ursuala@example.com", "name" => "Ursula"}} = data
    end
  end

  @users_doc """
  query getUsers{
   users{
     id
     name
     email
     uploads {
       title
       description
     }
   }
  }
  """

  describe "@users" do
    test "Returns a list of all users" do
      assert {:ok, user1} = Accounts.create_user(@user1_params)
      assert {:ok, user2} = Accounts.create_user(@user2_params)
      assert {:ok, user3} = Accounts.create_user(@user3_params)

      assert {:ok, %{data: data}} = Absinthe.run(@users_doc, Schema)

      assert %{"users" => users} = data

      assert List.last(users)["id"] === to_string(user3.id)
    end
  end
end

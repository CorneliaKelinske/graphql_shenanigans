# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
alias GraphqlPractice.{Content, Accounts, Repo}

if Mix.env() === :dev do
  IO.puts("=== SEEDING DATABASE ===")
  Accounts.create_user(%{name: "Ursula", email: "ursuala@example.com"})
  Accounts.create_user(%{name: "Birgitta", email: "birgitta@example.com"})

  Content.create_upload(%{title: "a picture", description: "a picture showing stuff", user_id: 1})

  Content.create_upload(%{
    title: "another picture",
    description: "a picture showing more stuff",
    user_id: 1
  })

  Content.create_upload(%{
    title: "Abendhimmel",
    description: "a picture showing the sunset",
    user_id: 2
  })

  Content.create_upload(%{
    title: "Morgenhimmel",
    description: "a picture showing the sunrise",
    user_id: 2
  })
end

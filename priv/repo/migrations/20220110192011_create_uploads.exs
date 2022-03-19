defmodule GraphqlShenanigans.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:uploads, [:user_id])
  end
end

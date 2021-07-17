defmodule Qiibee.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone_number, :string, null: false
      add :language, :string, null: false
      add :brand_id, references(:brands, type: :binary_id)

      timestamps()
    end

    create unique_index(:users, [:name, :brand_id])
    create unique_index(:users, [:email, :brand_id])
    create unique_index(:users, [:phone_number, :brand_id])
  end
end

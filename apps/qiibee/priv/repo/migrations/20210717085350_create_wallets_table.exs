defmodule Qiibee.Repo.Migrations.CreateWalletsTable do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :points, :integer, null: false
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create index(:wallets, [:user_id])
  end
end

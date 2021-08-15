defmodule Qiibee.Repo.Migrations.CreatebalancesTable do
  use Ecto.Migration

  def change do
    create table(:balances, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :points, :integer, null: false
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create index(:balances, [:user_id])
  end
end

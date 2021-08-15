defmodule Qiibee.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    Qiibee.Enums.TransactionType.create_type()

    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :reference, :string, null: false
      add :tx_hash, :string, null: false
      add :type, Qiibee.Enums.TransactionType.type(), null: false
      add :points, :integer, null: false
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:user_id, :reference])
  end
end

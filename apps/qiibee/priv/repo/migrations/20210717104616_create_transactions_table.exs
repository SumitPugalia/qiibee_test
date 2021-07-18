defmodule Qiibee.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    Qiibee.Enums.TransactionType.create_type()

    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :reference_code, :string, null: false
      add :type, Qiibee.Enums.TransactionType.type(), null: false
      add :points, :integer, null: false
      add :wallet_id, references(:wallets, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:wallet_id])
    create index(:transactions, [:wallet_id, :reference_code])
  end
end

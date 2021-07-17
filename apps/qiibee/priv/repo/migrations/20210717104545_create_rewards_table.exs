defmodule Qiibee.Repo.Migrations.CreateRewardsTable do
  use Ecto.Migration

  def change do
    create table(:rewards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :code, :string, null: false
      add :description, :string, null: false

      timestamps()
    end

    create index(:rewards, [:code])
  end
end

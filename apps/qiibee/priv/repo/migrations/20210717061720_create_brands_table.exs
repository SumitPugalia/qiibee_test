defmodule Qiibee.Repo.Migrations.CreateBrandsTable do
  use Ecto.Migration

  def change do
    create table(:brands, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :api_key, :string, null: false

      timestamps()
    end

    create unique_index(:brands, [:api_key])
  end
end

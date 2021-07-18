defmodule Qiibee.Repo.Migrations.CreateCouponsTable do
  use Ecto.Migration

  def change do
    create table(:coupons, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :code, :string, null: false
      add :expires_at, :utc_datetime_usec, null: false
      add :points, :integer, null: false
      add :brand_id, references(:brands, type: :binary_id)

      timestamps()
    end

    create index(:coupons, [:code])
  end
end

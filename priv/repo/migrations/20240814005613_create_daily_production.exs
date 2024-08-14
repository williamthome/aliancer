defmodule Aliancer.Repo.Migrations.CreateDailyProduction do
  use Ecto.Migration

  def change do
    create table(:daily_production) do
      add :date, :utc_datetime, null: false
      add :quantity, :decimal, null: false
      add :product_id, references(:products, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:daily_production, [:product_id])
  end
end

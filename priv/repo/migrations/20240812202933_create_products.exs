defmodule Aliancer.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :unit, :string
      add :cost, :decimal, precision: 12, scale: 4
      add :price, :decimal, precision: 10, scale: 2
      add :saleable, :boolean
      add :own_production, :boolean

      timestamps(type: :utc_datetime)
    end
  end
end

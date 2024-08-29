defmodule Aliancer.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :unit, :string, null: false
      add :unit_price, :decimal, null: false
      add :quantity, :decimal, null: false
      add :order_id, references(:orders, on_delete: :restrict), null: false
      add :product_id, references(:products, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:order_items, [:order_id])
    create index(:order_items, [:product_id])
  end
end

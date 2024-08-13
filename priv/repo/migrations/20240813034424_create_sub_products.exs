defmodule Aliancer.Repo.Migrations.CreateSubProducts do
  use Ecto.Migration

  def change do
    create table(:sub_products) do
      add :quantity, :decimal
      add :product_id, references(:products, on_delete: :nothing)
      add :sub_product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:sub_products, [:product_id])
    create index(:sub_products, [:sub_product_id])
  end
end

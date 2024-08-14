defmodule Aliancer.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :datetime, :utc_datetime, default: fragment("now()")
      add :address, :string
      add :customer_pickup, :boolean, default: false, null: false
      add :total, :decimal, default: 0
      add :paid, :boolean, default: false, null: false
      add :status, :string, default: "in_process"
      add :notes, :string
      add :customer_id, references(:customers, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:customer_id])
  end
end

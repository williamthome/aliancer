defmodule Aliancer.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :status, :string, default: "in_process"
      add :datetime, :utc_datetime, default: fragment("now()")
      add :notes, :string
      add :total, :decimal, default: 0
      add :paid, :boolean, default: false, null: false
      add :customer_pickup, :boolean, default: false, null: false
      add :addr_street, :string
      add :addr_number, :string
      add :addr_complement, :string
      add :addr_neighborhood, :string
      add :addr_city, :string
      add :addr_state, :string
      add :addr_postcode, :string
      add :addr_reference, :string
      add :customer_id, references(:customers, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:customer_id])
  end
end

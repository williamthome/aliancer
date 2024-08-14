defmodule Aliancer.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :address, :string
      add :phone, :string
      add :email, :string
      add :notes, :string

      timestamps(type: :utc_datetime)
    end
  end
end

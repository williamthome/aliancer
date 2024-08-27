defmodule Aliancer.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :person_type, :string, null: false
      add :first_name, :string
      add :second_name, :string
      add :id_number, :string
      add :notes, :string
      add :contact_phone, :string
      add :contact_email, :string
      add :addr_street, :string
      add :addr_number, :string
      add :addr_complement, :string
      add :addr_neighborhood, :string
      add :addr_city, :string
      add :addr_state, :string
      add :addr_postcode, :string
      add :addr_reference, :string

      timestamps(type: :utc_datetime)
    end
  end
end

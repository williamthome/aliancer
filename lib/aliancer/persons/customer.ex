defmodule Aliancer.Persons.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :name, :string
    field :address, :string
    field :phone, :string
    field :email, :string
    field :notes, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :address, :phone, :email, :notes])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
  end
end

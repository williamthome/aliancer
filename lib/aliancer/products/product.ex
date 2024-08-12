defmodule Aliancer.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :unit, Ecto.Enum, values: [:un, :m2, :m3]
    field :description, :string
    field :cost, :decimal
    field :price, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit, :cost, :price])
    |> validate_required([:name, :unit, :cost, :price])
  end
end

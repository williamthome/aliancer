defmodule Aliancer.Products.SubProducts.SubProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sub_products" do
    field :quantity, :decimal
    field :product_id, :id
    field :sub_product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sub_product, attrs) do
    sub_product
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end

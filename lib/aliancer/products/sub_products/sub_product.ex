defmodule Aliancer.Products.SubProducts.SubProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Products.Product

  schema "sub_products" do
    field :quantity, :decimal
    belongs_to :product, Product
    belongs_to :sub_product, Product, foreign_key: :sub_product_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sub_product, attrs) do
    sub_product
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> unique_constraint([:product, :sub_product],
      name: "sub_products_product_id_sub_product_id_index")
  end
end

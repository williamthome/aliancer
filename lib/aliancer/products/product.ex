defmodule Aliancer.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Products.SubProducts.SubProduct

  schema "products" do
    field :name, :string
    field :unit, Ecto.Enum, values: [:un, :m2, :m3, :m]
    field :description, :string
    field :cost, :decimal
    field :price, :decimal
    field :saleable, :boolean, default: true
    field :own_production, :boolean, default: false

    has_many :sub_products, SubProduct, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit, :cost, :price, :saleable, :own_production])
    |> validate_required([:name, :unit, :cost, :saleable])
    |> cast_price()
    |> cast_assoc(:sub_products,
      with: &SubProduct.changeset/2,
      sort_param: :sub_products_order,
      drop_param: :sub_products_delete
    )
  end

  defp cast_price(%{changes: %{saleable: false}} = changeset) do
    put_change(changeset, :price, nil)
  end

  defp cast_price(changeset), do: changeset
end

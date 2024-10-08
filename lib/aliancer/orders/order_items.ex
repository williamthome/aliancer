defmodule Aliancer.Orders.OrderItems do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Orders.Order
  alias Aliancer.Products.Product

  schema "order_items" do
    field :unit, :string
    field :unit_price, :decimal
    field :quantity, :decimal, default: Decimal.new(1)

    belongs_to :order, Order
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order_items, attrs) do
    order_items
    |> cast(attrs, [:unit, :unit_price, :quantity, :order_id, :product_id])
    |> validate_required([:unit, :unit_price, :quantity, :order_id, :product_id])
  end
end

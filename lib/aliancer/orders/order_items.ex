defmodule Aliancer.Orders.OrderItems do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :total, :decimal
    field :quantity, :decimal
    field :order_id, :id
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order_items, attrs) do
    order_items
    |> cast(attrs, [:quantity, :total])
    |> validate_required([:quantity, :total])
  end
end

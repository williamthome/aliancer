defmodule Aliancer.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Persons.Customer
  alias Aliancer.Orders.OrderItems

  schema "orders" do
    field :status, Ecto.Enum,
      values: [
        :in_process,
        :paused,
        :canceled,
        :in_production,
        :ready_for_dispatch,
        :partially_dispatched,
        :attempted_dispatch,
        :dispatched,
        :delayed,
        :returned,
        :partially_returned,
        :lost,
        :awaiting_pickup,
        :completed
      ]

    field :total, :decimal
    field :address, :string
    field :datetime, :utc_datetime
    field :customer_pickup, :boolean, default: false
    field :paid, :boolean, default: false
    field :notes, :string
    belongs_to :customer, Customer

    has_many :items, OrderItems, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    attrs = resolve_address(attrs)

    order
    |> cast(attrs, [
      :datetime,
      :address,
      :customer_pickup,
      :total,
      :paid,
      :status,
      :notes,
      :customer_id
    ])
    |> validate_required([:datetime, :status, :customer_id])
    |> cast_assoc(:items,
      with: &OrderItems.changeset/2,
      sort_param: :items_order,
      drop_param: :items_delete
    )
  end

  defp resolve_address(%{customer_pickup: true} = attrs) do
    Map.put(attrs, :address, nil)
  end

  defp resolve_address(attrs), do: attrs
end

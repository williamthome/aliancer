defmodule Aliancer.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Persons.Customer

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

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:datetime, :address, :customer_pickup, :total, :paid, :status, :notes])
    |> validate_required([:datetime, :status, :customer_id])
  end
end

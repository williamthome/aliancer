defmodule Aliancer.Orders.Order do
  use Gettext, backend: AliancerWeb.Gettext
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
    |> cast_address()
    |> validate_required([:datetime, :status, :customer_id])
    |> cast_assoc(:items,
      with: &OrderItems.changeset/2,
      sort_param: :items_order,
      drop_param: :items_delete
    )
  end

  defp cast_address(%{changes: %{customer_pickup: true}} = changeset) do
    put_change(changeset, :address, nil)
  end

  defp cast_address(changeset), do: changeset

  def statuses_select_options do
    for s <- Ecto.Enum.values(Aliancer.Orders.Order, :status), into: %{} do
      {status_label(s), s}
    end
  end

  def status_label(:in_process), do: gettext("In process")
  def status_label(:paused), do: gettext("Paused")
  def status_label(:canceled), do: gettext("Canceled")
  def status_label(:in_production), do: gettext("In production")
  def status_label(:ready_for_dispatch), do: gettext("Ready for dispatch")
  def status_label(:partially_dispatched), do: gettext("Partially dispatched")
  def status_label(:attempted_dispatch), do: gettext("Attempted dispatch")
  def status_label(:dispatched), do: gettext("Dispatched")
  def status_label(:delayed), do: gettext("Delayed")
  def status_label(:returned), do: gettext("Returned")
  def status_label(:partially_returned), do: gettext("Partially returned")
  def status_label(:lost), do: gettext("Lost")
  def status_label(:awaiting_pickup), do: gettext("Awaiting pickup")
  def status_label(:completed), do: gettext("Completed")
end

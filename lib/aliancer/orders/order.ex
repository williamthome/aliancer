defmodule Aliancer.Orders.Order do
  use Gettext, backend: AliancerWeb.Gettext
  use Ecto.Schema
  import Ecto.Changeset

  alias Aliancer.Persons.Customer
  alias Aliancer.Orders.OrderItems
  alias Aliancer.Products

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

    field :datetime, :utc_datetime
    field :notes, :string
    field :total, :decimal
    field :paid, :boolean, default: false
    field :delivery_datetime, :utc_datetime
    field :customer_pickup, :boolean, default: false
    field :addr_street, :string
    field :addr_number, :string
    field :addr_complement, :string
    field :addr_neighborhood, :string
    field :addr_city, :string
    field :addr_state, :string
    field :addr_postcode, :string
    field :addr_reference, :string

    belongs_to :customer, Customer

    has_many :items, OrderItems, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :status,
      :datetime,
      :notes,
      :total,
      :paid,
      :delivery_datetime,
      :customer_pickup,
      :addr_street,
      :addr_number,
      :addr_complement,
      :addr_neighborhood,
      :addr_city,
      :addr_state,
      :addr_postcode,
      :addr_reference,
      :customer_id
    ])
    |> cast_address()
    |> validate_required([:datetime, :status, :customer_id])
    |> validate_length(:addr_state, is: 2)
    |> cast_assoc(:items,
      with: &OrderItems.changeset/2,
      sort_param: :items_order,
      drop_param: :items_delete
    )
    |> calculate_total
  end

  defp cast_address(%{changes: %{customer_pickup: true}} = changeset) do
    change(changeset,
      addr_street: nil,
      addr_number: nil,
      addr_complement: nil,
      addr_neighborhood: nil,
      addr_city: nil,
      addr_state: nil,
      addr_postcode: nil,
      addr_reference: nil
    )
  end

  defp cast_address(changeset), do: changeset

  defp calculate_total(changeset) do
    items = get_field(changeset, :items)

    total =
      Enum.reduce(items, Decimal.new(0), fn item, acc ->
        case item do
          %{product_id: nil} ->
            acc

          %{unit_price: nil} ->
            Products.get_product!(item.product_id).price
            |> Decimal.mult(item.quantity)
            |> Decimal.add(acc)
            |> Decimal.round(2)

          %{} ->
            item.unit_price
            |> Decimal.mult(item.quantity)
            |> Decimal.add(acc)
            |> Decimal.round(2)
        end
      end)

    put_change(changeset, :total, total)
  end

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

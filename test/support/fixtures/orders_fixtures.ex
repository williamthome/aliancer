defmodule Aliancer.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        customer_pickup: false,
        datetime: ~U[2024-08-13 20:32:00Z],
        notes: "some notes",
        paid: true,
        status: :in_process,
        total: "120.5"
      })
      |> norm_attrs()
      |> Aliancer.Orders.create_order()

    order
  end

  def norm_attrs(attrs) do
    Enum.reduce(attrs, %{}, fn
      {key, value}, acc when is_atom(key) -> Map.put(acc, Atom.to_string(key), value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, key, value)
    end)
  end

  @doc """
  Generate a order_items.
  """
  def order_items_fixture(attrs \\ %{}) do
    {:ok, order_items} =
      attrs
      |> Enum.into(%{
        unit: "m",
        unit_price: "1",
        quantity: "120.5",
        total: "120.5"
      })
      |> Aliancer.Orders.create_order_items()

    order_items
  end
end

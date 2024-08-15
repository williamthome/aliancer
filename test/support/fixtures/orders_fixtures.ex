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
        address: "some address",
        customer_pickup: false,
        datetime: ~U[2024-08-13 20:32:00Z],
        notes: "some notes",
        paid: true,
        status: :in_process,
        total: "120.5"
      })
      |> Aliancer.Orders.create_order()

    order
  end

  @doc """
  Generate a order_items.
  """
  def order_items_fixture(attrs \\ %{}) do
    {:ok, order_items} =
      attrs
      |> Enum.into(%{
        quantity: "120.5",
        total: "120.5"
      })
      |> Aliancer.Orders.create_order_items()

    order_items
  end
end

defmodule Aliancer.OrdersTest do
  use Aliancer.DataCase

  alias Aliancer.Orders

  describe "orders" do
    alias Aliancer.Orders.Order

    import Aliancer.OrdersFixtures

    @invalid_attrs %{
      status: nil,
      total: nil,
      address: nil,
      datetime: nil,
      customer_pickup: nil,
      paid: nil,
      notes: nil
    }

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        status: :in_process,
        total: "120.5",
        address: "some address",
        datetime: ~U[2024-08-13 20:32:00Z],
        customer_pickup: true,
        paid: true,
        notes: "some notes"
      }

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.status == :in_process
      assert order.total == Decimal.new("120.5")
      assert order.address == "some address"
      assert order.datetime == ~U[2024-08-13 20:32:00Z]
      assert order.customer_pickup == true
      assert order.paid == true
      assert order.notes == "some notes"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        status: :paused,
        total: "456.7",
        address: "some updated address",
        datetime: ~U[2024-08-14 20:32:00Z],
        customer_pickup: false,
        paid: false,
        notes: "some updated notes"
      }

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.status == :paused
      assert order.total == Decimal.new("456.7")
      assert order.address == "some updated address"
      assert order.datetime == ~U[2024-08-14 20:32:00Z]
      assert order.customer_pickup == false
      assert order.paid == false
      assert order.notes == "some updated notes"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end

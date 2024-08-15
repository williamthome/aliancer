defmodule Aliancer.OrdersTest do
  use Aliancer.DataCase

  alias Aliancer.Orders

  describe "orders" do
    alias Aliancer.Orders.Order

    import Aliancer.OrdersFixtures
    import Aliancer.PersonsFixtures

    @invalid_attrs %{
      status: nil,
      total: nil,
      address: nil,
      datetime: nil,
      customer_id: nil,
      customer_pickup: nil,
      paid: nil,
      notes: nil
    }

    test "list_orders/0 returns all orders" do
      customer = customer_fixture()

      order =
        order_fixture(%{customer_id: customer.id})
        |> Map.put(:customer, customer)
        |> Ecto.reset_fields([:items])

      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      customer = customer_fixture()

      order =
        order_fixture(%{customer_id: customer.id})
        |> Map.put(:customer, customer)

      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      customer = customer_fixture()

      valid_attrs =
        norm_attrs(%{
          status: :in_process,
          total: "120.5",
          address: "some address",
          datetime: ~U[2024-08-13 20:32:00Z],
          customer_id: customer.id,
          customer_pickup: true,
          paid: true,
          notes: "some notes"
        })

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.status == :in_process
      assert order.total == Decimal.new("120.5")
      assert order.address == nil
      assert order.datetime == ~U[2024-08-13 20:32:00Z]
      assert order.customer_pickup == true
      assert order.paid == true
      assert order.notes == "some notes"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})

      update_attrs =
        norm_attrs(%{
          status: :paused,
          total: "456.7",
          address: "some updated address",
          datetime: ~U[2024-08-14 20:32:00Z],
          customer_pickup: false,
          paid: false,
          notes: "some updated notes"
        })

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
      customer = customer_fixture()

      order =
        order_fixture(%{customer_id: customer.id})
        |> Map.put(:customer, customer)

      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, norm_attrs(@invalid_attrs))
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end

  describe "order_items" do
    alias Aliancer.Orders.OrderItems

    import Aliancer.PersonsFixtures
    import Aliancer.ProductsFixtures
    import Aliancer.OrdersFixtures

    @invalid_attrs %{total: nil, quantity: nil}

    test "list_order_items/0 returns all order_items" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      assert Orders.list_order_items() == [order_items]
    end

    test "get_order_items!/1 returns the order_items with given id" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      assert Orders.get_order_items!(order_items.id) == order_items
    end

    test "create_order_items/1 with valid data creates a order_items" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()

      valid_attrs = %{
        order_id: order.id,
        product_id: product.id,
        total: "120.5",
        quantity: "120.5"
      }

      assert {:ok, %OrderItems{} = order_items} = Orders.create_order_items(valid_attrs)
      assert order_items.total == Decimal.new("120.5")
      assert order_items.quantity == Decimal.new("120.5")
    end

    test "create_order_items/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_items(@invalid_attrs)
    end

    test "update_order_items/2 with valid data updates the order_items" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      update_attrs = %{total: "456.7", quantity: "456.7"}

      assert {:ok, %OrderItems{} = order_items} =
               Orders.update_order_items(order_items, update_attrs)

      assert order_items.total == Decimal.new("456.7")
      assert order_items.quantity == Decimal.new("456.7")
    end

    test "update_order_items/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      assert {:error, %Ecto.Changeset{}} = Orders.update_order_items(order_items, @invalid_attrs)
      assert order_items == Orders.get_order_items!(order_items.id)
    end

    test "delete_order_items/1 deletes the order_items" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      assert {:ok, %OrderItems{}} = Orders.delete_order_items(order_items)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_items!(order_items.id) end
    end

    test "change_order_items/1 returns a order_items changeset" do
      customer = customer_fixture()
      order = order_fixture(%{customer_id: customer.id})
      product = product_fixture()
      order_items = order_items_fixture(%{order_id: order.id, product_id: product.id})
      assert %Ecto.Changeset{} = Orders.change_order_items(order_items)
    end
  end
end

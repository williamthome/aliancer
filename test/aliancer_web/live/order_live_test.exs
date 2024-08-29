defmodule AliancerWeb.OrderLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.OrdersFixtures
  import Aliancer.PersonsFixtures
  import Aliancer.AccountsFixtures

  @create_attrs %{
    status: :in_process,
    datetime: "2024-08-13T20:32:00Z",
    notes: "some notes"
  }
  @update_attrs %{
    status: :paused,
    notes: "some updated notes"
  }
  @invalid_attrs %{
    customer_id: nil,
    notes: nil
  }

  defp authenticate(%{conn: conn}) do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(conn, user)}
  end

  defp create_order(_) do
    customer = customer_fixture()

    order =
      order_fixture(%{customer_id: customer.id})
      |> Map.put(:customer, customer)

    %{order: order}
  end

  describe "Index" do
    setup [:authenticate, :create_order]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, _index_live, html} = live(conn, ~p"/orders")

      assert html =~ "Listing Orders"
      assert html =~ order.notes
    end

    test "saves new order", %{conn: conn} do
      customer = customer_fixture()

      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("a", "New Order") |> render_click() =~
               "New Order"

      assert_patch(index_live, ~p"/orders/new")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#order-form", order: Map.put(@create_attrs, :customer_id, customer.id))
             |> render_submit()

      assert_patch(index_live, ~p"/orders")

      html = render(index_live)
      assert html =~ "Order created successfully"
      assert html =~ "some notes"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      new_customer = customer_fixture()

      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("#orders-#{order.id} a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(index_live, ~p"/orders/#{order}/edit")

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#order-form", order: Map.put(@update_attrs, :customer_id, new_customer.id))
             |> render_submit()

      assert_patch(index_live, ~p"/orders")

      html = render(index_live)
      assert html =~ "Order updated successfully"
      refute has_element?(index_live, "#order_notes")
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("#orders-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#orders-#{order.id}")
    end
  end

  describe "Show" do
    setup [:authenticate, :create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, ~p"/orders/#{order}")

      assert html =~ "Show Order"
      assert html =~ order.notes
    end

    test "updates order within modal", %{conn: conn, order: order} do
      new_customer = customer_fixture()

      {:ok, show_live, _html} = live(conn, ~p"/orders/#{order}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(show_live, ~p"/orders/#{order}/show/edit")

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#order-form", order: Map.put(@update_attrs, :customer_id, new_customer.id))
             |> render_submit()

      assert_patch(show_live, ~p"/orders/#{order}")

      html = render(show_live)
      assert html =~ "Order updated successfully"
      refute has_element?(show_live, "#order_notes")
    end
  end
end

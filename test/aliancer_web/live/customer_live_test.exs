defmodule AliancerWeb.CustomerLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.PersonsFixtures
  import Aliancer.AccountsFixtures

  @create_attrs %{
    person_type: "natural",
    first_name: "some first_name",
    second_name: "some second_name",
    id_number: "0",
    notes: "some notes",
    contact_phone: "some contact_phone",
    contact_email: "some contact_email",
    addr_street: "some addr_street",
    addr_number: "some addr_number",
    addr_complement: "some addr_complement",
    addr_neighborhood: "some addr_neighborhood",
    addr_city: "some addr_city",
    addr_state: "SC",
    addr_postcode: "some addr_postcode",
    addr_reference: "some addr_reference"
  }
  @update_attrs %{
    person_type: "legal",
    first_name: "some updated first_name",
    second_name: "some updated second_name",
    id_number: "0",
    notes: "some updated notes",
    contact_phone: "some updated contact_phone",
    contact_email: "some updated contact_email",
    addr_street: "some updated addr_street",
    addr_number: "some updated addr_number",
    addr_complement: "some updated addr_complement",
    addr_neighborhood: "some updated addr_neighborhood",
    addr_city: "some updated addr_city",
    addr_state: "RS",
    addr_postcode: "some updated addr_postcode",
    addr_reference: "some updated addr_reference"
  }
  @invalid_attrs %{
    first_name: nil,
    second_name: nil,
    id_number: nil,
    notes: nil,
    contact_phone: nil,
    contact_email: nil,
    addr_street: nil,
    addr_number: nil,
    addr_complement: nil,
    addr_neighborhood: nil,
    addr_city: nil,
    addr_state: nil,
    addr_postcode: nil,
    addr_reference: nil
  }

  defp authenticate(%{conn: conn}) do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(conn, user)}
  end

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end

  describe "Index" do
    setup [:authenticate, :create_customer]

    test "lists all customers", %{conn: conn, customer: customer} do
      {:ok, _index_live, html} = live(conn, ~p"/customers")

      assert html =~ "Listing Customers"
      assert html =~ customer.first_name
    end

    test "saves new customer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/customers")

      assert index_live |> element("a", "New Customer") |> render_click() =~
               "New Customer"

      assert_patch(index_live, ~p"/customers/new")

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#customer-form", customer: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/customers")

      html = render(index_live)
      assert html =~ "Customer created successfully"
      assert html =~ "some first_name"
    end

    test "updates customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, ~p"/customers")

      assert index_live |> element("#customers-#{customer.id} a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(index_live, ~p"/customers/#{customer}/edit")

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#customer-form", customer: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/customers")

      html = render(index_live)
      assert html =~ "Customer updated successfully"
      assert html =~ "some updated first_name"
    end

    test "deletes customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, ~p"/customers")

      assert index_live |> element("#customers-#{customer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#customers-#{customer.id}")
    end
  end

  describe "Show" do
    setup [:authenticate, :create_customer]

    test "displays customer", %{conn: conn, customer: customer} do
      {:ok, _show_live, html} = live(conn, ~p"/customers/#{customer}")

      assert html =~ "Show Customer"
      assert html =~ customer.first_name
    end

    test "updates customer within modal", %{conn: conn, customer: customer} do
      {:ok, show_live, _html} = live(conn, ~p"/customers/#{customer}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(show_live, ~p"/customers/#{customer}/show/edit")

      assert show_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#customer-form", customer: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/customers/#{customer}")

      html = render(show_live)
      assert html =~ "Customer updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end

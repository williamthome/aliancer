defmodule AliancerWeb.SubProductLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.Products.SubProductsFixtures

  @create_attrs %{quantity: "120.5"}
  @update_attrs %{quantity: "456.7"}
  @invalid_attrs %{quantity: nil}

  defp create_sub_product(_) do
    sub_product = sub_product_fixture()
    %{sub_product: sub_product}
  end

  describe "Index" do
    setup [:create_sub_product]

    test "lists all sub_products", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/sub_products")

      assert html =~ "Listing Sub products"
    end

    test "saves new sub_product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sub_products")

      assert index_live |> element("a", "New Sub product") |> render_click() =~
               "New Sub product"

      assert_patch(index_live, ~p"/sub_products/new")

      assert index_live
             |> form("#sub_product-form", sub_product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sub_product-form", sub_product: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sub_products")

      html = render(index_live)
      assert html =~ "Sub product created successfully"
    end

    test "updates sub_product in listing", %{conn: conn, sub_product: sub_product} do
      {:ok, index_live, _html} = live(conn, ~p"/sub_products")

      assert index_live |> element("#sub_products-#{sub_product.id} a", "Edit") |> render_click() =~
               "Edit Sub product"

      assert_patch(index_live, ~p"/sub_products/#{sub_product}/edit")

      assert index_live
             |> form("#sub_product-form", sub_product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sub_product-form", sub_product: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sub_products")

      html = render(index_live)
      assert html =~ "Sub product updated successfully"
    end

    test "deletes sub_product in listing", %{conn: conn, sub_product: sub_product} do
      {:ok, index_live, _html} = live(conn, ~p"/sub_products")

      assert index_live |> element("#sub_products-#{sub_product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sub_products-#{sub_product.id}")
    end
  end

  describe "Show" do
    setup [:create_sub_product]

    test "displays sub_product", %{conn: conn, sub_product: sub_product} do
      {:ok, _show_live, html} = live(conn, ~p"/sub_products/#{sub_product}")

      assert html =~ "Show Sub product"
    end

    test "updates sub_product within modal", %{conn: conn, sub_product: sub_product} do
      {:ok, show_live, _html} = live(conn, ~p"/sub_products/#{sub_product}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sub product"

      assert_patch(show_live, ~p"/sub_products/#{sub_product}/show/edit")

      assert show_live
             |> form("#sub_product-form", sub_product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sub_product-form", sub_product: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sub_products/#{sub_product}")

      html = render(show_live)
      assert html =~ "Sub product updated successfully"
    end
  end
end

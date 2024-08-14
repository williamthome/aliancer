defmodule AliancerWeb.DailyProductionLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.Products.DailyProductionFixtures

  @create_attrs %{date: "2024-08-13T00:56:00Z", quantity: "120.5"}
  @update_attrs %{date: "2024-08-14T00:56:00Z", quantity: "456.7"}
  @invalid_attrs %{date: nil, quantity: nil}

  defp create_daily_production(_) do
    daily_production = daily_production_fixture()
    %{daily_production: daily_production}
  end

  describe "Index" do
    setup [:create_daily_production]

    test "lists all daily_production", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/daily_production")

      assert html =~ "Listing Daily production"
    end

    test "saves new daily_production", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/daily_production")

      assert index_live |> element("a", "New Daily production") |> render_click() =~
               "New Daily production"

      assert_patch(index_live, ~p"/daily_production/new")

      assert index_live
             |> form("#daily_production-form", daily_production: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#daily_production-form", daily_production: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/daily_production")

      html = render(index_live)
      assert html =~ "Daily production created successfully"
    end

    test "updates daily_production in listing", %{conn: conn, daily_production: daily_production} do
      {:ok, index_live, _html} = live(conn, ~p"/daily_production")

      assert index_live |> element("#daily_production-#{daily_production.id} a", "Edit") |> render_click() =~
               "Edit Daily production"

      assert_patch(index_live, ~p"/daily_production/#{daily_production}/edit")

      assert index_live
             |> form("#daily_production-form", daily_production: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#daily_production-form", daily_production: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/daily_production")

      html = render(index_live)
      assert html =~ "Daily production updated successfully"
    end

    test "deletes daily_production in listing", %{conn: conn, daily_production: daily_production} do
      {:ok, index_live, _html} = live(conn, ~p"/daily_production")

      assert index_live |> element("#daily_production-#{daily_production.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#daily_production-#{daily_production.id}")
    end
  end

  describe "Show" do
    setup [:create_daily_production]

    test "displays daily_production", %{conn: conn, daily_production: daily_production} do
      {:ok, _show_live, html} = live(conn, ~p"/daily_production/#{daily_production}")

      assert html =~ "Show Daily production"
    end

    test "updates daily_production within modal", %{conn: conn, daily_production: daily_production} do
      {:ok, show_live, _html} = live(conn, ~p"/daily_production/#{daily_production}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Daily production"

      assert_patch(show_live, ~p"/daily_production/#{daily_production}/show/edit")

      assert show_live
             |> form("#daily_production-form", daily_production: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#daily_production-form", daily_production: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/daily_production/#{daily_production}")

      html = render(show_live)
      assert html =~ "Daily production updated successfully"
    end
  end
end

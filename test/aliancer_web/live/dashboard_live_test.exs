defmodule AliancerWeb.DashboardLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    test "render", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboard")

      assert html =~ "Aliancer Engenharia e Topografia"
    end
  end
end

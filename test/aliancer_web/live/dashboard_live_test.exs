defmodule AliancerWeb.DashboardLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.AccountsFixtures

  defp authenticate(%{conn: conn}) do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(conn, user)}
  end

  describe "Index" do
    setup [:authenticate]

    test "render", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Goal"
    end
  end
end

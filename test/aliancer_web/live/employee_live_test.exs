defmodule AliancerWeb.EmployeeLiveTest do
  use AliancerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aliancer.PersonsFixtures
  import Aliancer.AccountsFixtures

  @create_attrs %{
    name: "some name",
    salary: "120.5",
    hire_date: "2024-08-15",
    dismiss_date: "2024-08-15",
    job_name: "some job_name",
    birth_date: "2024-08-15"
  }
  @update_attrs %{
    name: "some updated name",
    salary: "456.7",
    hire_date: "2024-08-16",
    dismiss_date: "2024-08-16",
    job_name: "some updated job_name",
    birth_date: "2024-08-16"
  }
  @invalid_attrs %{
    name: nil,
    salary: nil,
    hire_date: nil,
    dismiss_date: nil,
    job_name: nil,
    birth_date: nil
  }

  defp authenticate(%{conn: conn}) do
    password = valid_user_password()
    user = user_fixture(%{password: password, is_admin: true})
    %{conn: log_in_user(conn, user)}
  end

  defp create_employee(_) do
    employee = employee_fixture()
    %{employee: employee}
  end

  describe "Index" do
    setup [:authenticate, :create_employee]

    test "lists all employees", %{conn: conn, employee: employee} do
      {:ok, _index_live, html} = live(conn, ~p"/employees")

      assert html =~ "Listing Employees"
      assert html =~ employee.name
    end

    test "saves new employee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/employees")

      assert index_live |> element("a", "New Employee") |> render_click() =~
               "New Employee"

      assert_patch(index_live, ~p"/employees/new")

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#employee-form", employee: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/employees")

      html = render(index_live)
      assert html =~ "Employee created successfully"
      assert html =~ "some name"
    end

    test "updates employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, ~p"/employees")

      assert index_live |> element("#employees-#{employee.id} a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(index_live, ~p"/employees/#{employee}/edit")

      assert index_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#employee-form", employee: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/employees")

      html = render(index_live)
      assert html =~ "Employee updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes employee in listing", %{conn: conn, employee: employee} do
      {:ok, index_live, _html} = live(conn, ~p"/employees")

      assert index_live |> element("#employees-#{employee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#employees-#{employee.id}")
    end
  end

  describe "Show" do
    setup [:authenticate, :create_employee]

    test "displays employee", %{conn: conn, employee: employee} do
      {:ok, _show_live, html} = live(conn, ~p"/employees/#{employee}")

      assert html =~ "Show Employee"
      assert html =~ employee.name
    end

    test "updates employee within modal", %{conn: conn, employee: employee} do
      {:ok, show_live, _html} = live(conn, ~p"/employees/#{employee}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Employee"

      assert_patch(show_live, ~p"/employees/#{employee}/show/edit")

      assert show_live
             |> form("#employee-form", employee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#employee-form", employee: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/employees/#{employee}")

      html = render(show_live)
      assert html =~ "Employee updated successfully"
      assert html =~ "some updated name"
    end
  end
end

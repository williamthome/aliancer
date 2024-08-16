defmodule AliancerWeb.EmployeeLive.Index do
  use AliancerWeb, :live_view

  alias Aliancer.Persons
  alias Aliancer.Persons.Employee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :employees, Persons.list_employees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Employee")
    |> assign(:employee, Persons.get_employee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Employee")
    |> assign(:employee, %Employee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Employees")
    |> assign(:employee, nil)
  end

  @impl true
  def handle_info({AliancerWeb.EmployeeLive.FormComponent, {:saved, employee}}, socket) do
    {:noreply, stream_insert(socket, :employees, employee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    employee = Persons.get_employee!(id)
    {:ok, _} = Persons.delete_employee(employee)

    {:noreply, stream_delete(socket, :employees, employee)}
  end
end

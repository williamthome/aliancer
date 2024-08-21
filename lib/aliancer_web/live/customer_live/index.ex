defmodule AliancerWeb.CustomerLive.Index do
  use AliancerWeb, :live_view

  alias Aliancer.Persons
  alias Aliancer.Persons.Customer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :customers, Persons.list_customers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Customer"))
    |> assign(:customer, Persons.get_customer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Customer"))
    |> assign(:customer, %Customer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Customers"))
    |> assign(:customer, nil)
  end

  @impl true
  def handle_info({AliancerWeb.CustomerLive.FormComponent, {:saved, customer}}, socket) do
    {:noreply, stream_insert(socket, :customers, customer)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    customer = Persons.get_customer!(id)
    {:ok, _} = Persons.delete_customer(customer)

    {:noreply, stream_delete(socket, :customers, customer)}
  end
end

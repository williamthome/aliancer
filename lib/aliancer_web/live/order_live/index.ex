defmodule AliancerWeb.OrderLive.Index do
  use AliancerWeb, :live_view

  alias Aliancer.Orders
  alias Aliancer.Orders.Order

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :orders, Orders.list_orders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Order"))
    |> assign(:order, Orders.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Order"))
    |> assign(:order, %Order{
      datetime: DateTime.utc_now(),
      total: 0,
      status: :in_process
    })
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Orders"))
    |> assign(:order, nil)
  end

  @impl true
  def handle_info({AliancerWeb.OrderLive.FormComponent, {:saved, order}}, socket) do
    {:noreply, stream_insert(socket, :orders, order)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Orders.get_order!(id)
    {:ok, _} = Orders.delete_order(order)

    {:noreply, stream_delete(socket, :orders, order)}
  end
end

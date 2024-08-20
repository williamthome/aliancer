defmodule AliancerWeb.OrderLive.Show do
  use AliancerWeb, :live_view

  alias Aliancer.Orders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Orders.get_order!(id))}
  end

  defp page_title(:show), do: gettext("Show Order")
  defp page_title(:edit), do: gettext("Edit Order")
end

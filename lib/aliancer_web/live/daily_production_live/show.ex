defmodule AliancerWeb.DailyProductionLive.Show do
  use AliancerWeb, :live_view

  alias Aliancer.Products.Production

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:daily_production, Production.get_daily_production!(id))}
  end

  defp page_title(:show), do: gettext("Show Daily production")
  defp page_title(:edit), do: gettext("Edit Daily production")
end

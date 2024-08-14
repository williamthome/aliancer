defmodule AliancerWeb.DailyProductionLive.Index do
  use AliancerWeb, :live_view

  alias Aliancer.Products.DailyProduction
  alias Aliancer.Products.DailyProduction.DailyProduction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :daily_production_collection, DailyProduction.list_daily_production())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Daily production")
    |> assign(:daily_production, DailyProduction.get_daily_production!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Daily production")
    |> assign(:daily_production, %DailyProduction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Daily production")
    |> assign(:daily_production, nil)
  end

  @impl true
  def handle_info({AliancerWeb.DailyProductionLive.FormComponent, {:saved, daily_production}}, socket) do
    {:noreply, stream_insert(socket, :daily_production_collection, daily_production)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    daily_production = DailyProduction.get_daily_production!(id)
    {:ok, _} = DailyProduction.delete_daily_production(daily_production)

    {:noreply, stream_delete(socket, :daily_production_collection, daily_production)}
  end
end
defmodule AliancerWeb.SubProductLive.Index do
  use AliancerWeb, :live_view

  alias Aliancer.Products.SubProducts
  alias Aliancer.Products.SubProducts.SubProduct

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sub_products, SubProducts.list_sub_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sub product")
    |> assign(:sub_product, SubProducts.get_sub_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sub product")
    |> assign(:sub_product, %SubProduct{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sub products")
    |> assign(:sub_product, nil)
  end

  @impl true
  def handle_info({AliancerWeb.SubProductLive.FormComponent, {:saved, sub_product}}, socket) do
    {:noreply, stream_insert(socket, :sub_products, sub_product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sub_product = SubProducts.get_sub_product!(id)
    {:ok, _} = SubProducts.delete_sub_product(sub_product)

    {:noreply, stream_delete(socket, :sub_products, sub_product)}
  end
end

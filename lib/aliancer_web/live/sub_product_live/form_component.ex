defmodule AliancerWeb.SubProductLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Products.SubProducts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage sub_product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sub_product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:quantity]} type="number" label="Quantity" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sub product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sub_product: sub_product} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(SubProducts.change_sub_product(sub_product))
     end)}
  end

  @impl true
  def handle_event("validate", %{"sub_product" => sub_product_params}, socket) do
    changeset = SubProducts.change_sub_product(socket.assigns.sub_product, sub_product_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"sub_product" => sub_product_params}, socket) do
    save_sub_product(socket, socket.assigns.action, sub_product_params)
  end

  defp save_sub_product(socket, :edit, sub_product_params) do
    case SubProducts.update_sub_product(socket.assigns.sub_product, sub_product_params) do
      {:ok, sub_product} ->
        notify_parent({:saved, sub_product})

        {:noreply,
         socket
         |> put_flash(:info, "Sub product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_sub_product(socket, :new, sub_product_params) do
    case SubProducts.create_sub_product(sub_product_params) do
      {:ok, sub_product} ->
        notify_parent({:saved, sub_product})

        {:noreply,
         socket
         |> put_flash(:info, "Sub product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

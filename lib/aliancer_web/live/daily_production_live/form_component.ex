defmodule AliancerWeb.DailyProductionLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Products
  alias Aliancer.Products.Production

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage daily_production records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="daily_production-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:product_id]} label="Product" type="select" options={@products} />
        <.input field={@form[:quantity]} type="number" label="Quantity" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Daily production</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{daily_production: daily_production} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(daily_production)
      |> assign_products()

    {:ok, socket}
  end

  defp assign_form(socket, daily_production) do
    assign_new(socket, :form, fn ->
      to_form(Production.change_daily_production(daily_production))
    end)
  end

  defp assign_products(socket) do
    products =
      Products.list_own_production_products()
      |> Enum.map(&{&1.name, &1.id})

    assign(socket, :products, products)
  end

  @impl true
  def handle_event("validate", %{"daily_production" => daily_production_params}, socket) do
    changeset =
      Production.change_daily_production(socket.assigns.daily_production, daily_production_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"daily_production" => daily_production_params}, socket) do
    save_daily_production(socket, socket.assigns.action, daily_production_params)
  end

  defp save_daily_production(socket, :edit, daily_production_params) do
    case Production.update_daily_production(
           socket.assigns.daily_production,
           daily_production_params
         ) do
      {:ok, daily_production} ->
        notify_parent({:saved, daily_production})

        {:noreply,
         socket
         |> put_flash(:info, "Daily production updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_daily_production(socket, :new, daily_production_params) do
    case Production.create_daily_production(daily_production_params) do
      {:ok, daily_production} ->
        notify_parent({:saved, daily_production})

        {:noreply,
         socket
         |> put_flash(:info, "Daily production created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

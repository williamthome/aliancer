defmodule AliancerWeb.OrderLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Orders
  alias Aliancer.Persons
  alias Aliancer.Products

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= gettext("Use this form to manage order records in your database.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="order-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.tabs>
          <:tab slug="info" label={gettext("Details")} class="pt-8 space-y-8" active>
            <.input
              field={@form[:customer_id]}
              label={gettext("Customer")}
              type="select"
              prompt={gettext("Choose a value")}
              options={@customers}
            />
            <.input
              field={@form[:status]}
              type="select"
              label={gettext("Status")}
              options={Aliancer.Orders.Order.statuses_select_options()}
            />
            <.input field={@form[:datetime]} type="datetime-local" label={gettext("Datetime")} />
            <.input field={@form[:notes]} type="textarea" label={gettext("Notes")} />
          </:tab>
          <:tab slug="items" label={gettext("Items")} class="pt-8 space-y-8">
            <.header>
              <%= gettext("Listing Items") %>
              <:actions>
                <label class="rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 cursor-pointer">
                  <input type="checkbox" name="order[items_order][]" class="hidden" />
                  <span><%= gettext("Add Item") %></span>
                </label>
              </:actions>
            </.header>

            <div class="space-y-2">
              <.inputs_for :let={item_form} field={@form[:items]}>
                <input type="hidden" name="order[items_order][]" value={item_form.index} />
                <div class="flex space-x-2">
                  <.input
                    field={item_form[:product_id]}
                    label={if item_form.index == 0, do: gettext("Item")}
                    type="select"
                    options={@products}
                    control_class="grow"
                  />
                  <.input
                    field={item_form[:quantity]}
                    type="number"
                    label={if item_form.index == 0, do: gettext("Quantity")}
                    step="any"
                  />
                  <.input
                    field={item_form[:total]}
                    type="number"
                    label={if item_form.index == 0, do: gettext("Total")}
                    step="any"
                  />
                  <div class="flex flex-col">
                    <label
                      :if={item_form.index == 0}
                      class="block text-sm font-semibold leading-6 text-zinc-800 invisible"
                    >
                      X
                    </label>
                    <label class="mt-2 flex items-center justify-center grow cursor-pointer">
                      <input
                        type="checkbox"
                        name="order[items_delete][]"
                        value={item_form.index}
                        class="hidden"
                      />
                      <.icon name="hero-x-mark" />
                    </label>
                  </div>
                </div>
              </.inputs_for>

              <div
                :if={!is_list(@form[:items].value) || @form[:items].value == []}
                class="text-center px-3 py-5 border"
              >
                <.header>
                  <%= gettext("Nothing!") %>
                  <:subtitle>
                    <%= gettext("Please add the order items") %>
                  </:subtitle>
                </.header>
              </div>
            </div>
            <.input field={@form[:total]} type="number" label={gettext("Total")} step="any" />
            <.input field={@form[:paid]} type="checkbox" label={gettext("Paid")} />
          </:tab>
          <:tab slug="address" label={gettext("Address")} class="pt-8 space-y-8">
            <.input
              field={@form[:customer_pickup]}
              type="checkbox"
              label={gettext("Customer pickup")}
            />
            <.input
              :if={@form[:customer_pickup].value not in [true, "true"]}
              field={@form[:address]}
              type="textarea"
              label={gettext("Address")}
            />
          </:tab>
        </.tabs>

        <:actions>
          <.button phx-disable-with={gettext("Saving...")}>
            <%= gettext("Save Order") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{order: order} = assigns, socket) do
    changeset = Orders.change_order(order)

    socket =
      socket
      |> assign(assigns)
      |> assign_new(:form, fn -> to_form(changeset) end)
      |> assign_customers()
      |> assign_products()

    {:ok, socket}
  end

  defp assign_customers(socket) do
    customers =
      Persons.list_customers()
      |> Enum.map(&{&1.first_name, &1.id})

    assign(socket, :customers, customers)
  end

  defp assign_products(socket) do
    products =
      Products.list_saleable_products()
      |> Enum.map(&{&1.name, &1.id})

    assign(socket, :products, products)
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset = Orders.change_order(socket.assigns.order, order_params)

    socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, socket.assigns.action, order_params)
  end

  defp save_order(socket, :edit, order_params) do
    case Orders.update_order(socket.assigns.order, order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Order updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_order(socket, :new, order_params) do
    case Orders.create_order(order_params) do
      {:ok, order} ->
        notify_parent({:saved, order})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Order created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

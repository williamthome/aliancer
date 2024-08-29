defmodule AliancerWeb.ProductLive.FormComponent do
  use AliancerWeb, :live_component

  alias Aliancer.Products

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= gettext("Use this form to manage product records in your database.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label={gettext("Name")} />
        <.input field={@form[:description]} type="text" label={gettext("Description")} />
        <.input
          field={@form[:unit]}
          type="select"
          label={gettext("Unit")}
          prompt={gettext("Choose a value")}
          options={Ecto.Enum.values(Aliancer.Products.Product, :unit)}
        />
        <.input field={@form[:cost]} type="number" label={gettext("Cost")} step="any" />
        <.input field={@form[:saleable]} type="checkbox" label={gettext("Saleable")} />
        <.input
          :if={@form[:saleable].value}
          field={@form[:price]}
          type="number"
          label={gettext("Price")}
          step="any"
        />
        <div :if={@form[:saleable].value} class="flex items-center justify-between">
          <span><%= gettext("Profit margin") %></span>
          <span><%= calculate_profit_margin(@form[:cost].value, @form[:price].value) %></span>
        </div>
        <.input field={@form[:own_production]} type="checkbox" label={gettext("Own production")} />

        <.header>
          <%= gettext("Listing Sub products") %>
          <:actions>
            <label class="rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 cursor-pointer">
              <input type="checkbox" name="product[sub_products_order][]" class="hidden" />
              <span><%= gettext("Add Sub Product") %></span>
            </label>
          </:actions>
        </.header>

        <div class="space-y-2">
          <.inputs_for :let={sub_product_form} field={@form[:sub_products]}>
            <input type="hidden" name="product[sub_products_order][]" value={sub_product_form.index} />
            <div class="flex space-x-2">
              <.input
                field={sub_product_form[:id]}
                label={if sub_product_form.index == 0, do: gettext("Product")}
                type="select"
                options={@sub_products}
                control_class="grow"
              />
              <.input
                field={sub_product_form[:quantity]}
                type="number"
                label={if sub_product_form.index == 0, do: gettext("Quantity")}
                step="any"
              />
              <div class="flex flex-col">
                <label
                  :if={sub_product_form.index == 0}
                  class="block text-sm font-semibold leading-6 text-zinc-800 invisible"
                >
                  X
                </label>
                <label class="mt-2 flex items-center justify-center grow cursor-pointer">
                  <input
                    type="checkbox"
                    name="product[sub_products_delete][]"
                    value={sub_product_form.index}
                    class="hidden"
                  />
                  <.icon name="hero-x-mark" />
                </label>
              </div>
            </div>
          </.inputs_for>

          <div
            :if={!is_list(@form[:sub_products].value) || @form[:sub_products].value == []}
            class="text-center px-3 py-5 border"
          >
            <.header>
              <%= gettext("Nothing!") %>
              <:subtitle>
                <%= gettext("Add products that compose that product") %>
              </:subtitle>
            </.header>
          </div>
        </div>

        <:actions>
          <.button phx-disable-with={gettext("Saving...")}>
            <%= gettext("Save Product") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(product)
      |> assign_sub_products(product)

    {:ok, socket}
  end

  defp assign_form(socket, product) do
    assign_new(socket, :form, fn ->
      to_form(Products.change_product(product))
    end)
  end

  defp assign_sub_products(socket, _product) do
    sub_products =
      Products.list_products()
      |> Enum.map(&{&1.name, &1.id})

    assign(socket, :sub_products, sub_products)
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset = Products.change_product(socket.assigns.product, product_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Product updated successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Products.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, gettext("Product created successfully"))
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp calculate_profit_margin(cost, price) do
    do_calculate_profit_margin(parse_decimal(cost), parse_decimal(price))
  end

  defp do_calculate_profit_margin(%Decimal{} = cost, %Decimal{} = price) do
    profit_margin =
      Decimal.div(cost, price)
      |> Decimal.sub(1)
      |> Decimal.mult(-100)
      |> Decimal.round(3)
      |> Decimal.to_string()

    "#{profit_margin} %"
  end

  defp do_calculate_profit_margin(_cost, _price), do: gettext("NaN")

  defp parse_decimal(value) when is_binary(value) do
    case Decimal.parse(value) do
      {decimal, _remainder} ->
        decimal

      :error ->
        :error
    end
  end

  defp parse_decimal(%Decimal{} = decimal), do: decimal
  defp parse_decimal(_value), do: :error
end

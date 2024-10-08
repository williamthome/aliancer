defmodule Aliancer.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Aliancer.Repo

  alias Aliancer.Orders.Order
  alias Aliancer.Orders.OrderItems

  @doc """
  Returns the orders count.

  ## Examples

      iex> count_orders()
      0

  """
  def count_orders, do: Repo.aggregate(Order, :count)

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
    |> Repo.preload(:customer)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id) do
    Repo.get!(Order, id)
    |> Repo.preload(:customer)
    |> Repo.preload(:items)
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    Repo.transaction(fn ->
      case %Order{}
           |> Order.changeset(Map.drop(attrs, ["items", "items_order", "items_delete"]))
           |> Repo.insert() do
        {:ok, order} ->
          items =
            Map.new(Map.get(attrs, "items", []), fn {index, item} ->
              {index, Map.put(item, "order_id", order.id)}
            end)

          case order
               |> Repo.preload(:items)
               |> Ecto.Changeset.cast(Map.put(attrs, "items", items), [])
               |> Ecto.Changeset.cast_assoc(:items,
                 with: &OrderItems.changeset/2,
                 sort_param: :items_order,
                 drop_param: :items_delete
               )
               |> Repo.update() do
            {:ok, updated_order} ->
              updated_order
              |> Repo.preload(:customer)
              |> Repo.preload(:items)

            {:error, reason} ->
              Repo.rollback(reason)
          end

        {:error, reason} ->
          Repo.rollback(reason)
      end
    end)
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    items =
      Map.new(Map.get(attrs, "items", []), fn {index, item} ->
        {index, Map.put(item, "order_id", order.id)}
      end)

    case order
         |> Order.changeset(Map.put(attrs, "items", items))
         |> Repo.update() do
      {:ok, updated_order} ->
        {:ok,
         updated_order
         |> Repo.preload(:customer)
         |> Repo.preload(:items)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias Aliancer.Orders.OrderItems

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItems{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItems)
  end

  @doc """
  Gets a single order_items.

  Raises `Ecto.NoResultsError` if the Order items does not exist.

  ## Examples

      iex> get_order_items!(123)
      %OrderItems{}

      iex> get_order_items!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_items!(id), do: Repo.get!(OrderItems, id)

  @doc """
  Creates a order_items.

  ## Examples

      iex> create_order_items(%{field: value})
      {:ok, %OrderItems{}}

      iex> create_order_items(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_items(attrs \\ %{}) do
    %OrderItems{}
    |> OrderItems.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_items.

  ## Examples

      iex> update_order_items(order_items, %{field: new_value})
      {:ok, %OrderItems{}}

      iex> update_order_items(order_items, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_items(%OrderItems{} = order_items, attrs) do
    order_items
    |> OrderItems.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order_items.

  ## Examples

      iex> delete_order_items(order_items)
      {:ok, %OrderItems{}}

      iex> delete_order_items(order_items)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_items(%OrderItems{} = order_items) do
    Repo.delete(order_items)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_items changes.

  ## Examples

      iex> change_order_items(order_items)
      %Ecto.Changeset{data: %OrderItems{}}

  """
  def change_order_items(%OrderItems{} = order_items, attrs \\ %{}) do
    OrderItems.changeset(order_items, attrs)
  end
end

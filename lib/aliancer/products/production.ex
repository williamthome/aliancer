defmodule Aliancer.Products.Production do
  @moduledoc """
  The Products.Production context.
  """

  import Ecto.Query, warn: false
  alias Aliancer.Repo

  alias Aliancer.Products.Production.DailyProduction
  alias Aliancer.Products.Product

  @doc """
  Returns the list of daily_production for chart use.

  ## Examples

      iex> daily_production_series()
      [[~D[2024-08-13], 90.0], [~D[2024-08-14], 461.968], ...]

  """
  def daily_production_series do
    from(dp in DailyProduction,
      join: p in Product,
      on: dp.product_id == p.id,
      group_by: dp.date,
      select: {dp.date, sum(p.price * dp.quantity)}
    )
    |> Repo.all()
    |> Enum.map(fn {date, total} ->
      [date, Decimal.to_float(total)]
    end)
  end

  @doc """
  Returns the list of daily_production.

  ## Examples

      iex> list_daily_production()
      [%DailyProduction{}, ...]

  """
  def list_daily_production do
    Repo.all(DailyProduction)
    |> Repo.preload(:product)
  end

  @doc """
  Gets a single daily_production.

  Raises `Ecto.NoResultsError` if the Daily production does not exist.

  ## Examples

      iex> get_daily_production!(123)
      %DailyProduction{}

      iex> get_daily_production!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_production!(id) do
    Repo.get!(DailyProduction, id)
    |> Repo.preload(:product)
  end

  @doc """
  Creates a daily_production.

  ## Examples

      iex> create_daily_production(%{field: value})
      {:ok, %DailyProduction{}}

      iex> create_daily_production(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_production(attrs \\ %{}) do
    case %DailyProduction{}
         |> DailyProduction.changeset(attrs)
         |> Repo.insert() do
      {:ok, daily_production} ->
        {:ok, Repo.preload(daily_production, :product)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Updates a daily_production.

  ## Examples

      iex> update_daily_production(daily_production, %{field: new_value})
      {:ok, %DailyProduction{}}

      iex> update_daily_production(daily_production, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_production(%DailyProduction{} = daily_production, attrs) do
    daily_production
    |> DailyProduction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a daily_production.

  ## Examples

      iex> delete_daily_production(daily_production)
      {:ok, %DailyProduction{}}

      iex> delete_daily_production(daily_production)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_production(%DailyProduction{} = daily_production) do
    Repo.delete(daily_production)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_production changes.

  ## Examples

      iex> change_daily_production(daily_production)
      %Ecto.Changeset{data: %DailyProduction{}}

  """
  def change_daily_production(%DailyProduction{} = daily_production, attrs \\ %{}) do
    DailyProduction.changeset(daily_production, attrs)
  end
end

defmodule Aliancer.Products.ProductionFixtures do
  import Aliancer.ProductsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Products.Production` context.
  """

  @doc """
  Generate a daily_production.
  """
  def daily_production_fixture(attrs \\ %{}) do
    product = product_fixture()

    {:ok, daily_production} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-08-13],
        quantity: "120.5",
        product_id: product.id
      })
      |> Aliancer.Products.Production.create_daily_production()

    daily_production
    |> Map.put(:product, product)
  end
end

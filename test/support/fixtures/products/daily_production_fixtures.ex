defmodule Aliancer.Products.DailyProductionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Products.DailyProduction` context.
  """

  @doc """
  Generate a daily_production.
  """
  def daily_production_fixture(attrs \\ %{}) do
    {:ok, daily_production} =
      attrs
      |> Enum.into(%{
        date: ~U[2024-08-13 00:56:00Z],
        quantity: "120.5"
      })
      |> Aliancer.Products.DailyProduction.create_daily_production()

    daily_production
  end
end

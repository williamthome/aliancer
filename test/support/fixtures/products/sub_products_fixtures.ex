defmodule Aliancer.Products.SubProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aliancer.Products.SubProducts` context.
  """

  @doc """
  Generate a sub_product.
  """
  def sub_product_fixture(attrs \\ %{}) do
    {:ok, sub_product} =
      attrs
      |> Enum.into(%{
        quantity: "120.5"
      })
      |> Aliancer.Products.SubProducts.create_sub_product()

    sub_product
  end
end

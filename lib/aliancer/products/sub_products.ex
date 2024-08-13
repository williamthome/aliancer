defmodule Aliancer.Products.SubProducts do
  @moduledoc """
  The Products.SubProducts context.
  """

  import Ecto.Query, warn: false
  alias Aliancer.Repo

  alias Aliancer.Products.SubProducts.SubProduct

  @doc """
  Returns the list of sub_products.

  ## Examples

      iex> list_sub_products()
      [%SubProduct{}, ...]

  """
  def list_sub_products do
    Repo.all(SubProduct)
  end

  @doc """
  Gets a single sub_product.

  Raises `Ecto.NoResultsError` if the Sub product does not exist.

  ## Examples

      iex> get_sub_product!(123)
      %SubProduct{}

      iex> get_sub_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sub_product!(id), do: Repo.get!(SubProduct, id)

  @doc """
  Creates a sub_product.

  ## Examples

      iex> create_sub_product(%{field: value})
      {:ok, %SubProduct{}}

      iex> create_sub_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sub_product(attrs \\ %{}) do
    %SubProduct{}
    |> SubProduct.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sub_product.

  ## Examples

      iex> update_sub_product(sub_product, %{field: new_value})
      {:ok, %SubProduct{}}

      iex> update_sub_product(sub_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sub_product(%SubProduct{} = sub_product, attrs) do
    sub_product
    |> SubProduct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sub_product.

  ## Examples

      iex> delete_sub_product(sub_product)
      {:ok, %SubProduct{}}

      iex> delete_sub_product(sub_product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sub_product(%SubProduct{} = sub_product) do
    Repo.delete(sub_product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sub_product changes.

  ## Examples

      iex> change_sub_product(sub_product)
      %Ecto.Changeset{data: %SubProduct{}}

  """
  def change_sub_product(%SubProduct{} = sub_product, attrs \\ %{}) do
    SubProduct.changeset(sub_product, attrs)
  end
end

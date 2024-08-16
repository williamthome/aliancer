defmodule Aliancer.Persons.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :name, :string
    field :salary, :decimal
    field :hire_date, :date
    field :dismiss_date, :date
    field :job_name, :string
    field :birth_date, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :salary, :hire_date, :dismiss_date, :job_name, :birth_date])
    |> validate_required([:name, :job_name])
  end
end

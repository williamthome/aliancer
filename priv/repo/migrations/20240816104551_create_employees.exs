defmodule Aliancer.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string, null: false
      add :salary, :decimal
      add :hire_date, :date
      add :dismiss_date, :date
      add :job_name, :string, null: false
      add :birth_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end

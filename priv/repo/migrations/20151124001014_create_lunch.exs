defmodule Lunchify.Repo.Migrations.CreateLunch do
  use Ecto.Migration

  def change do
    create table(:lunches) do
      add :tags, {:array, :text}
      add :body, :text

      timestamps
    end

  end
end

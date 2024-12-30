defmodule Backend.Repo.Migrations.CreateTaxas do
  use Ecto.Migration

  def change do
    create table(:recintos) do
      add :recintoId, :integer
      add :nome, :string

      timestamps(type: :utc_datetime)
    end

    create table(:servicos) do
      add :recinto_id, references(:recintos)
      add :nome, :string
      add :obrigatorio, :boolean, default: false, null: false
      add :hasPeriodo, :boolean, default: false, null: false
      add :cobranca, :string
      add :aplicaTaxaMercadoria, :boolean, default: false, null: false
      add :aplicaTaxaContainer, :boolean, default: false, null: false
      add :valor, :float

      timestamps(type: :utc_datetime)
    end

    create table(:taxas) do
      add :recinto_id, references(:recintos)
      add :servico_id, references(:servicos)
      add :tipo, :string
      add :valores, :map

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule Backend.Taxas.Taxa do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Recintos.Recinto
  alias Backend.Servicos.Servico
  alias Backend.Taxas.Valores

  @derive {Jason.Encoder, [except: [:__meta__, :recinto, :servico]]}
  schema "taxas" do
    belongs_to :recinto, Recinto
    belongs_to :servico, Servico
    field :tipo, Ecto.Enum, values: [:publica, :negociada]
    # embeds_one :valores, Valores
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(taxa, attrs) do
    taxa
    |> cast(attrs, [:servico_id, :recinto_id, :tipo])
    |> validate_required([:servico_id, :recinto_id, :tipo])
    # Fix here for embedding
    # |> cast_embed(:valores, required: true)
    |> foreign_key_constraint(:servico_id, message: "Servico not found")
    |> foreign_key_constraint(:recinto_id, message: "Recinto not found")
  end
end

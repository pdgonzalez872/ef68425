defmodule AcceptanceTest do
  use Ef68425.DataCase

  # https://elixirforum.com/t/ecto-not-finding-my-constraints-when-inserting-in-sqlite/68425
  test "should work" do
    payload = """
    {"taxa":
      {
        "recinto_id" : 1,
        "servico_id" : 2,
        "tipo": "publica",
        "valores": {
            "container": {
                "Carga Solta": "",
                "Flat Rack": "",
                "Normal": 1,
                "Open Top":""
            },
            "mercadoria": {
                "IMO": "",
                "Normal": "",
                "Oversize": "",
                "Oversize IMO": "",
                "Reefer": ""
            }
        }
      }
    }
    """

    change =
      payload
      |> Jason.decode!()
      |> then(fn decoded ->
        Backend.Taxas.Taxa.changeset(%Backend.Taxas.Taxa{}, decoded["taxa"])
      end)

    assert {:error,
            %{
              errors: [
                recinto_id:
                  {"Recinto not found",
                   [constraint: :foreign, constraint_name: "taxas_recinto_id_fkey"]}
              ]
            }} = Ef68425.Repo.insert(change)
  end
end

defmodule ReceiptDecoder.BenchTest do
  use ExUnit.Case
  require Logger

  test "bench decode receipt" do
    inputs = %{
      "receipt" => read_receipt_file("receipt"),
      "auto_renewable_receipt" => read_receipt_file("auto_renewable_receipt")
    }

    Benchee.run(
      %{
        "normal" => fn receipt ->
          {:ok, _} = ReceiptDecoder.decode(receipt)
        end
      },
      inputs: inputs
    )
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!()
    |> String.replace("\n", "")
  end
end

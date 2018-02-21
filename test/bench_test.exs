defmodule ReceiptDecoder.BenchTest do
  use ExUnit.Case
  require Logger

  test "bench decode receipt" do
    if run_bench?() do
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
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!()
    |> String.replace("\n", "")
  end

  defp run_bench? do
    elixir_version = System.version()

    case Version.compare("1.4.0", elixir_version) do
      :lt ->
        true

      :eq ->
        true

      :gt ->
        Logger.warn("Skip bench for Elixir #{elixir_version}")
        false
    end
  end
end

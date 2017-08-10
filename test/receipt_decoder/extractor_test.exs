defmodule ReceiptDecoder.ExtractorTest do
  use ExUnit.Case
  doctest ReceiptDecoder

  alias ReceiptDecoder.Extractor

  describe "get_payload/1" do
    test "decode receipt & returns the payload" do
      base64_receipt = read_receipt_file("receipt")

      {:ok, data} = Extractor.get_payload(base64_receipt)

      assert {:ReceiptAttribute, 8, 1, <<22, 0>>} == List.first(data)
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!
    |> String.replace("\n", "")
  end
end

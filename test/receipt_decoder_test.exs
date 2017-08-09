defmodule ReceiptDecoderTest do
  use ExUnit.Case
  doctest ReceiptDecoder

  describe "decode/1" do
    test "decode receipt" do
      base64_receipt = read_receipt_file("receipt")

      {:ok, data} = ReceiptDecoder.decode(base64_receipt)

      assert {:ReceiptAttribute, 8, 1, <<22, 0>>} == List.first(data)
    end

    test "parse receipt" do
      base64_receipt = read_receipt_file("auto_renewable_receipt")

      {:ok, data} = ReceiptDecoder.decode(base64_receipt)

      application_version =
        data
        |> ReceiptDecoder.parse()
        |> Keyword.get(:application_version)

      assert application_version == "1445"
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!
    |> String.replace("\n", "")
  end
end


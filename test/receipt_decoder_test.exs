defmodule ReceiptDecoderTest do
  use ExUnit.Case

  alias ReceiptDecoder

  describe "decode/1" do
    test "decode a receipt" do
      base64_receipt = read_receipt_file("receipt")

      {:ok, data} = ReceiptDecoder.decode(base64_receipt)

      assert %ReceiptDecoder.AppReceipt{} = data
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!()
    |> String.replace("\n", "")
  end
end
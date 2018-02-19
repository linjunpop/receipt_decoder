defmodule ReceiptDecoder.ExtractorTest do
  use ExUnit.Case

  alias ReceiptDecoder.Extractor

  describe "decode_receipt/1" do
    test "extract receipt from the pkcs7 container" do
      base64_receipt = read_receipt_file("auto_renewable_receipt")

      receipt = Extractor.decode_receipt(base64_receipt)

      assert {:ContentInfo, _, _} = receipt
    end
  end

  describe "extract_payload/1" do
    test "extract payload from receipt" do
      base64_receipt = read_receipt_file("auto_renewable_receipt")

      receipt = Extractor.decode_receipt(base64_receipt)
      result = Extractor.extract_payload(receipt)

      assert {:ok, _payload} = result
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!()
    |> String.replace("\n", "")
  end
end

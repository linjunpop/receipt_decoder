defmodule ReceiptDecoder.VerifierTest do
  use ExUnit.Case

  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Verifier

  describe "get_payload/1" do
    test "decode receipt & returns the payload" do
      base64_receipt = read_receipt_file("auto_renewable_receipt")

      receipt = Extractor.decode_receipt(base64_receipt)

      assert Verifier.verify(receipt)
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!
    |> String.replace("\n", "")
  end
end

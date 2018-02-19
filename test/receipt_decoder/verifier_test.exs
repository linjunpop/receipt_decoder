defmodule ReceiptDecoder.VerifierTest do
  use ExUnit.Case

  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Verifier

  describe "verify/1" do
    test "verify a valid receipt" do
      base64_receipt = read_receipt_file("receipt")

      receipt = Extractor.decode_receipt(base64_receipt)

      assert :ok == Verifier.verify(receipt)
    end
  end

  defp read_receipt_file(filename) do
    "test/fixtures/#{filename}"
    |> File.read!()
    |> String.replace("\n", "")
  end
end

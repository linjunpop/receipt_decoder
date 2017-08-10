defmodule ReceiptDecoder do
  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Parser

  def decode(base64_receipt) do
    base64_receipt
    |> Extractor.get_payload()
    |> Parser.parse()
  end
end

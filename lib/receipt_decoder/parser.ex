defmodule ReceiptDecoder.Parser do
  alias ReceiptDecoder.Parser.App

  def parse(payload) do
    payload
    |> App.parse()
  end
end

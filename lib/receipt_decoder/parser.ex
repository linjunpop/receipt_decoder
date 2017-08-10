defmodule ReceiptDecoder.Parser do
  @moduledoc false

  alias ReceiptDecoder.Parser.App

  @spec parse(keyword) :: map
  def parse(payload) do
    payload
    |> App.parse()
  end
end

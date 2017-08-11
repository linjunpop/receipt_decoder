defmodule ReceiptDecoder do
  @moduledoc """
  Decode iOS App receipt
  """

  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Parser

  @doc """
  Decode iOS App receipt

  ## Example

  ```elixir
  iex> ReceiptDecoder.decode(BASE64_ENCODED_RECEIPT)
  %{application_version: "1241", ...}
  ````
  """
  @spec decode(String.t) :: {:ok, map} | {:error, any}
  def decode(base64_receipt) do
    with(
      {:ok, payload} <- Extractor.get_payload(base64_receipt),
      data <- Parser.parse(payload)
    ) do
      {:ok, data}
    else
      err -> err
    end
  end
end

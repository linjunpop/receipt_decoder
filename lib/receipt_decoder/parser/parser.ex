defmodule ReceiptDecoder.Parser do
  @moduledoc false

  alias ReceiptDecoder.Parser.App
  alias ReceiptDecoder.AppReceipt

  @spec parse_payload(bitstring()) :: {:ok, AppReceipt.t()} | {:error, any}
  def parse_payload(payload_data) do
    case decode_payload(payload_data) do
      {:ok, payload} ->
        {:ok, App.parse(payload)}

      {:error, {:asn1, _}} ->
        {:error, :invalid_payload}
    end
  end

  defp decode_payload(payload_data) do
    :ReceiptModule.decode(:Payload, payload_data)
  end
end
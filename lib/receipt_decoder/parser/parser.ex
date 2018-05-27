defmodule ReceiptDecoder.Parser do
  @moduledoc """
  The Payload Parser
  """

  alias ReceiptDecoder.Parser.App
  alias ReceiptDecoder.AppReceipt

  @doc """
  Parse the payload, return a parsed `ReceiptDecoder.AppReceipt` struct.
  """
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

defmodule ReceiptDecoder.Extractor do
  @moduledoc """
  Extract content from the receipt
  """

  @type receipt_t :: {:ContentInfo, tuple(), tuple()}

  @doc """
  Decode the Base64-encoded receipt
  """
  @spec decode_receipt(String.t()) :: {:ok, receipt_t} | {:error, any}
  def decode_receipt(base64_receipt) do
    base64_receipt
    |> wrap_pkcs7()
    |> decode_pkcs7()
  end

  @doc """
  Extract the payload from receipt
  """
  @spec extract_payload(receipt_t) :: {:ok, bitstring()} | {:error, any}
  def extract_payload(receipt) do
    case receipt do
      {
        :ContentInfo,
        _,
        {
          :SignedData,
          :sdVer1,
          _,
          {:ContentInfo, _, payload},
          _,
          :asn1_NOVALUE,
          _
        }
      } ->
        {:ok, payload}

      _ ->
        {:error, :payload_not_found}
    end
  end

  defp wrap_pkcs7(base64_receipt) do
    ~s"""
    -----BEGIN PKCS7-----
    #{base64_receipt}
    -----END PKCS7-----
    """
  end

  defp decode_pkcs7(pkcs7_pem) do
    try do
      entry =
        pkcs7_pem
        |> :public_key.pem_decode()
        |> List.first()
        |> :public_key.pem_entry_decode()

      {:ok, entry}
    rescue
      _ -> {:error, :invalid_receipt}
    end
  end
end

defmodule ReceiptDecoder.Extractor do
  @moduledoc """
  Extract content of receipt
  """

  @type receipt_t :: {:ContentInfo, tuple(), tuple()}

  @doc """
  Decode Base64 encoded receipt
  """
  @spec extract_receipt(String.t()) :: receipt_t
  def extract_receipt(base64_receipt) do
    base64_receipt
    |> wrap_pkcs7()
    |> decode_pkcs7()
  end

  @doc """
  Get the raw encoded paylaod data
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
    pkcs7_pem
    |> :public_key.pem_decode()
    |> List.first()
    |> :public_key.pem_entry_decode()
  end
end
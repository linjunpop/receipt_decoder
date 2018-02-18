defmodule ReceiptDecoder.Extractor do
  @moduledoc """
  Extract content of receipt
  """

  @type receipt_t :: {:ContentInfo, tuple(), tuple()}

  @doc """
  Get the decoded payload from `base64_receipt`.
  """
  @spec get_payload(String.t()) :: {:ok, list()} | {:error, any}
  def get_payload(base64_receipt) do
    encoded_payload =
      base64_receipt
      |> decode_receipt()
      |> get_payload_data()

    :ReceiptModule.decode(:Payload, encoded_payload)
  end

  @doc """
  Decode Base64 encoded receipt
  """
  @spec decode_receipt(String.t()) :: receipt_t
  def decode_receipt(base64_receipt) do
    base64_receipt
    |> wrap_pkcs7()
    |> decode_pkcs7()
  end

  @doc """
  Get the raw encoded paylaod data
  """
  @spec get_payload_data(receipt_t) :: bitstring()
  def get_payload_data(receipt) do
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
    } = receipt

    payload
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
defmodule ReceiptDecoder.Extractor do
  @moduledoc false

  @spec get_payload(String.t()) :: {:ok, keyword} | {:error, any}
  def get_payload(base64_receipt) do
    encoded_payload =
      base64_receipt
      |> decode_receipt()
      |> find_payload()

    :ReceiptModule.decode(:Payload, encoded_payload)
  end

  def decode_receipt(base64_receipt) do
    base64_receipt
    |> wrap_pkcs7()
    |> decode_pkcs7()
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

  defp find_payload(data) do
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
    } = data

    payload
  end
end

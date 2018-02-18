defmodule ReceiptDecoder.Verifier do
  @moduledoc """
  Verify receipt
  """

  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Verifier.PublicKey
  alias ReceiptDecoder.Verifier.AppleRootCertificate

  require PublicKey

  require Record

  @apple_root_public_key AppleRootCertificate.public_key()

  @doc """
  Verify the receipt payload
  """
  @spec verify(tuple) :: :ok | {:error, any}
  def verify(receipt_payload) when is_tuple(receipt_payload) do
    {[itunes_cert, wwdr_cert, _bundled_root_cert], signer} = destruct_receipt(receipt_payload)

    with :ok <- verify_wwdr_cert(wwdr_cert),
         :ok <- verify_itunes_cert(itunes_cert, wwdr_cert),
         :ok <- verify_signature(signer, receipt_payload, itunes_cert) do
      :ok
    else
      {:error, msg} ->
        {:error, msg}
    end
  end

  defp verify_wwdr_cert({:certificate, cert}) do
    cert = :public_key.der_encode(:Certificate, cert)

    case :public_key.pkix_verify(cert, @apple_root_public_key) do
      true ->
        :ok

      false ->
        {:error, :invalid_wwdr_cert}
    end
  end

  defp extract_public_key({:certificate, cert}) do
    cert
    |> PublicKey.certificate(:tbsCertificate)
    |> PublicKey.tbs_certificate(:subjectPublicKeyInfo)
    |> PublicKey.subject_public_key_info(:subjectPublicKey)
    |> decode_public_key()
  end

  defp verify_itunes_cert({:certificate, cert}, wwdr_cert) do
    wwdr_public_key = extract_public_key(wwdr_cert)

    cert = :public_key.der_encode(:Certificate, cert)

    case :public_key.pkix_verify(cert, wwdr_public_key) do
      true ->
        :ok

      false ->
        {:error, :invalid_itunes_cert}
    end
  end

  defp decode_public_key(key) do
    :public_key.der_decode(:RSAPublicKey, key)
  end

  defp verify_signature(signer, receipt, itunes_cert) do
    signature = get_signer_signature(signer)
    payload = Extractor.get_payload_data(receipt)
    public_key = extract_public_key(itunes_cert)

    case :public_key.verify(payload, :sha, signature, public_key) do
      true ->
        :ok

      false ->
        {:error, :invalid_signer_signature}
    end
  end

  defp get_signer_signature(signer) do
    {
      :SignerInfo,
      :siVer1,
      _signer_identifier = {
        :IssuerAndSerialNumber,
        _issuer,
        _serial_number
      },
      _digest_algorithm,
      _authenticated_attributes,
      _digest_encryption_algorithm,
      encrypted_digest,
      _unauthenticated_attributes
    } = signer

    encrypted_digest
  end

  defp destruct_receipt(receipt) do
    {
      :ContentInfo,
      _content_type,
      _pkcs7_content = {
        :SignedData,
        :sdVer1,
        _digest_algorithms,
        {:ContentInfo, _, _data},
        {:certSet, certs},
        _cert_revocation_lists,
        {:siSet, [signer]}
      }
    } = receipt

    {certs, signer}
  end
end
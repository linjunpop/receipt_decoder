defmodule ReceiptDecoder.Verifier do
  @moduledoc """
  Verify receipt
  """

  alias ReceiptDecoder.Extractor
  alias ReceiptDecoder.Verifier.PublicKey
  alias ReceiptDecoder.Verifier.AppleRootCertificate

  require PublicKey

  @wwdr_cert_policies_extension_oid {1, 2, 840, 113_635, 100, 6, 2, 1}
  @itunes_cert_marker_extension_oid {1, 2, 840, 113_635, 100, 6, 11, 1}

  @doc """
  Verify the receipt
  """
  @spec verify(Extractor.receipt_t()) :: :ok | {:error, any}
  def verify(receipt) do
    {[itunes_cert, wwdr_cert, root_cert], signer} = destruct_receipt(receipt)

    with :ok <- verify_root_cert_fingerprint(root_cert),
         :ok <- verify_wwdr_cert(wwdr_cert),
         :ok <- verify_wwdr_cert_policies_extension_oid(wwdr_cert),
         :ok <- verify_itunes_cert(itunes_cert, wwdr_cert),
         :ok <- verify_itunes_cert_marker_extension_oid(itunes_cert),
         :ok <- verify_signature(signer, receipt, itunes_cert) do
      :ok
    else
      {:error, msg} ->
        {:error, msg}
    end
  end

  defp verify_root_cert_fingerprint({:certificate, root_cert}) do
    cert_bin = :public_key.pkix_encode(:Certificate, root_cert, :plain)

    fingerprint = :crypto.hash(:sha256, cert_bin)

    case AppleRootCertificate.fingerprint() do
      ^fingerprint ->
        :ok

      _ ->
        {:error, :invalid_root_cert_fingerprint}
    end
  end

  defp verify_wwdr_cert({:certificate, cert}) do
    cert = :public_key.der_encode(:Certificate, cert)

    case :public_key.pkix_verify(cert, AppleRootCertificate.public_key()) do
      true ->
        :ok

      false ->
        {:error, :invalid_wwdr_cert}
    end
  end

  defp verify_wwdr_cert_policies_extension_oid(wwdr_cert) do
    case find_matching_extension(wwdr_cert, @wwdr_cert_policies_extension_oid) do
      nil ->
        {:error, :wwdr_cert_policies_extension_oid_mismatch}

      _extension ->
        :ok
    end
  end

  defp verify_itunes_cert_marker_extension_oid(itunes_cert) do
    case find_matching_extension(itunes_cert, @itunes_cert_marker_extension_oid) do
      nil ->
        {:error, :itunes_cert_marker_extension_oid_mismatch}

      _extension ->
        :ok
    end
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

  defp extract_public_key({:certificate, cert}) do
    cert
    |> PublicKey.certificate(:tbsCertificate)
    |> PublicKey.tbs_certificate(:subjectPublicKeyInfo)
    |> PublicKey.subject_public_key_info(:subjectPublicKey)
    |> decode_public_key()
  end

  defp decode_public_key(key) do
    :public_key.der_decode(:RSAPublicKey, key)
  end

  defp find_matching_extension({:certificate, cert}, oid) do
    cert
    |> PublicKey.certificate(:tbsCertificate)
    |> PublicKey.tbs_certificate(:extensions)
    |> Enum.find(fn ext ->
      oid === PublicKey.extension(ext, :extnID)
    end)
  end

  defp verify_signature(signer, receipt, itunes_cert) do
    signature = get_signer_signature(signer)
    public_key = extract_public_key(itunes_cert)

    with {:ok, payload} <- Extractor.extract_payload(receipt),
         true <-
           :public_key.verify(payload, :sha256, signature, public_key) or
             :public_key.verify(payload, :sha, signature, public_key) do
      :ok
    else
      false ->
        {:error, :invalid_signer_signature}

      {:error, err} ->
        {:error, err}
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

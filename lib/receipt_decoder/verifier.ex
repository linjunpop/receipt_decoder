defmodule ReceiptDecoder.Verifier do
  alias ReceiptDecoder.PublicKey

  def verify(receipt) do
    {certs, signer} = destruct_receipt(receipt)

    cert = get_signed_cert(certs, signer)

    :public_key.pkix_verify(cert, PublicKey.default_public_key())
  end

  defp get_signed_cert(certs, signer) do
    serial_number = find_signer_serial_number(signer)

    {:certificate, cert} =
      certs
      |> Enum.find(fn(cert) -> cert_match?(cert, serial_number) end)

    :public_key.der_encode(:Certificate, cert)
  end

  defp find_signer_serial_number(signer) do
    {
      :SignerInfo,
      :siVer1,
      _signer_identifier = {
        :IssuerAndSerialNumber,
        _issuer,
        serial_number
      },
      _digest_algorithm,
      _authenticated_attributes,
      _digest_encryption_algorithm,
      _encrypted_digest,
      _unauthenticated_attributes
    } = signer

    serial_number
  end

  defp cert_match?(cert, serial_number) do
    {
      :certificate, {
        :Certificate, {
          :TBSCertificate, :v3, ^serial_number,
          _, _, _, _, _, _, _, _
        }, _, _
      }
    } |> match?(cert)
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

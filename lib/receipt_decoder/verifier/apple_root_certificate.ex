defmodule ReceiptDecoder.Verifier.AppleRootCertificate do
  @moduledoc false

  require ReceiptDecoder.Verifier.PublicKey
  alias ReceiptDecoder.Verifier.PublicKey

  @cert_filepath :receipt_decoder
                 |> :code.priv_dir()
                 |> Path.join("AppleIncRootCertificate.cer")
  @external_resource @cert_filepath

  @cert @cert_filepath
        |> File.read!()
        |> :public_key.pkix_decode_cert(:plain)

  def public_key do
    @cert
    |> PublicKey.certificate(:tbsCertificate)
    |> PublicKey.tbs_certificate(:subjectPublicKeyInfo)
    |> PublicKey.subject_public_key_info(:subjectPublicKey)
    |> decode_key()
  end

  def fingerprint do
    cert_bin = :public_key.pkix_encode(:Certificate, @cert, :plain)

    :crypto.hash(:sha256, cert_bin)
  end

  defp decode_key(key) do
    :public_key.der_decode(:RSAPublicKey, key)
  end
end

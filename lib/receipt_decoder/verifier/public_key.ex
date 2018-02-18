defmodule ReceiptDecoder.Verifier.PublicKey do
  @moduledoc false

  import Record, only: [defrecord: 2, extract: 2]

  @lib "public_key/include/public_key.hrl"

  defrecord :certificate, extract(:Certificate, from_lib: @lib)
  defrecord :tbs_certificate, extract(:TBSCertificate, from_lib: @lib)
  defrecord :subject_public_key_info, extract(:SubjectPublicKeyInfo, from_lib: @lib)
end
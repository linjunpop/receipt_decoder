defmodule Mix.Tasks.ReceiptDecoder.CompileAsn1 do
  @moduledoc false

  use Mix.Task

  @shortdoc "Compile the ASN.1 into Erlang modules"

  @impl true
  def run(_args) do
    mod = 'asn1/ReceiptModule.asn1'

    :asn1ct.compile(mod, [
      :ber,
      :der,
      :noobj,
      {:outdir, 'src'}
    ])
  end
end

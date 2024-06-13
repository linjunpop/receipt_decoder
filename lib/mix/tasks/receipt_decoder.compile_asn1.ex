defmodule Mix.Tasks.ReceiptDecoder.CompileAsn1 do
  @moduledoc false

  use Mix.Task

  @shortdoc "Compile the ASN.1 into Erlang modules"

  @impl true
  def run(_args) do
    # mod = ~c"asn1/ReceiptModule.asn1"

    :asn1ct.compile(~c"asn1/ReceiptModule.asn1", [
      :ber,
      :der,
      :noobj,
      {:outdir, ~c"src"}
    ])
  end
end

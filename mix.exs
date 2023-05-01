defmodule ReceiptDecoder.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :receipt_decoder,
      version: @version,
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/linjunpop/receipt_decoder",
      homepage_url: "https://github.com/linjunpop/receipt_decoder",
      docs: docs(),
      dialyzer: [plt_add_apps: [:mix, :public_key, :asn1]],
      xref: [exclude: [:asn1ct]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:public_key, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: [:dev, :docs]},
      {:benchee, "~> 1.0", only: [:dev, :test]}
    ]
  end

  defp description do
    "Decode iOS App receipt"
  end

  defp package do
    [
      name: :receipt_decoder,
      files: [
        "lib/receipt_decoder*",
        "src/ReceiptModule.{erl,hrl}",
        "priv/AppleIncRootCertificate.cer",
        "mix.exs",
        "README*",
        "LICENSE"
      ],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/linjunpop/receipt_decoder"
      }
    ]
  end

  defp docs do
    [
      main: "ReceiptDecoder",
      groups_for_modules: [
        Core: [
          ReceiptDecoder.Extractor,
          ReceiptDecoder.Verifier,
          ReceiptDecoder.Parser
        ],
        Data: [
          ReceiptDecoder.AppReceipt,
          ReceiptDecoder.IAPReceipt
        ]
      ]
    ]
  end
end

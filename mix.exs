defmodule ReceiptDecoder.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :receipt_decoder,
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/linjunpop/receipt_decoder",
      homepage_url: "https://github.com/linjunpop/receipt_decoder",
      docs: [
        main: "ReceiptDecoder"
      ],
      dialyzer: [plt_add_apps: [:mix, :public_key, :asn1]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.15", only: [:dev, :docs]}
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
end

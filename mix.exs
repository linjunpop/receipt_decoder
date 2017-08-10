defmodule ReceiptDecoder.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :receipt_decoder,
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [
        main: "ReceiptDecoder"
      ]
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
      {:ex_doc, "~> 0.15", only: [:dev, :docs]}
    ]
  end

  defp description do
    "Decode iOS App receipt"
  end

  defp package do
    [
      name: :receipt_decoder,
      files: ["lib/receipt_decoder*", "src/ReceiptModule.{erl,hrl}", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      source_url: "https://github.com/linjunpop/receipt_decoder",
      homepage_url: "https://github.com/linjunpop/receipt_decoder",
      links: %{
        "GitHub" => "https://github.com/linjunpop/receipt_decoder"
      }
    ]
  end
end

defmodule ReceiptDecoder.Mixfile do
  use Mix.Project

  def project do
    [
      app: :receipt_decoder,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
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
end

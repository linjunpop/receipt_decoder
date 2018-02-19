defmodule ReceiptDecoder.ParserTest do
  use ExUnit.Case

  alias ReceiptDecoder.Parser

  describe "parse_payload/1" do
    test "parse a valid payload" do
      {:ok, data} = Parser.parse_payload(payload())

      assert data.application_version == "1241"
      assert length(data.in_apps) == 2
    end

    test "parse an invalid payload" do
      {:error, error} = Parser.parse_payload(<<>>)

      assert error == :invalid_payload
    end
  end

  defp payload do
    "test/fixtures/payload"
    |> File.read!()
  end
end
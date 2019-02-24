defmodule ReceiptDecoder.Parser.Helper do
  @moduledoc false

  def extract_string(value) do
    <<_::bytes-size(1), len::integer-size(8), value_content::bytes-size(len)>> = value

    value_content
  end

  def extract_datetime(value) do
    value
    |> extract_string()
    |> format_datetime()
  end

  def extract_integer(value) do
    value
    |> extract_string()
    |> :crypto.bytes_to_integer()
  end

  defp format_datetime(""), do: nil

  defp format_datetime(value) do
    with {:ok, datetime, 0} <- DateTime.from_iso8601(value) do
      datetime
    end
  end
end

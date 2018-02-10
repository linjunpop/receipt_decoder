defmodule ReceiptDecoder.Util do
  @moduledoc false

  @spec format_datetime(String.t()) :: NaiveDateTime.t()
  def format_datetime(""), do: nil

  def format_datetime(value) do
    value
    |> NaiveDateTime.from_iso8601!()
  end
end

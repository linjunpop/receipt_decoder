defmodule ReceiptDecoder.Parser.IAP do
  @moduledoc false

  alias ReceiptDecoder.IAPReceipt
  alias ReceiptDecoder.Parser.Helper

  @spec parse(keyword) :: IAPReceipt.t()
  def parse(data) do
    attrs =
      data
      |> Enum.map(&do_parse/1)
      |> Enum.reject(fn {field, _} -> :unknown == field end)
      |> Enum.into(%{})

    struct(IAPReceipt, attrs)
  end

  defp do_parse({:InAppAttribute, 1701, _version, value}) do
    {:quantity, Helper.extract_integer(value)}
  end

  defp do_parse({:InAppAttribute, 1702, _version, value}) do
    {:product_id, Helper.extract_string(value)}
  end

  defp do_parse({:InAppAttribute, 1703, _version, value}) do
    {:transaction_id, Helper.extract_string(value)}
  end

  defp do_parse({:InAppAttribute, 1704, _version, value}) do
    {:purchase_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:InAppAttribute, 1705, _version, value}) do
    {:original_transaction_id, Helper.extract_string(value)}
  end

  defp do_parse({:InAppAttribute, 1706, _version, value}) do
    {:original_purchase_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:InAppAttribute, 1708, _version, value}) do
    {:expires_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:InAppAttribute, 1711, _version, value}) do
    {:web_order_line_item_id, Helper.extract_integer(value)}
  end

  defp do_parse({:InAppAttribute, 1712, _version, value}) do
    {:cancellation_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:InAppAttribute, 1719, _version, value}) do
    {:is_in_intro_offer_period, Helper.extract_integer(value)}
  end

  defp do_parse({:InAppAttribute, type, version, value}) do
    {:unknown, %{type: type, version: version, value: value}}
  end
end

defmodule ReceiptDecoder.Parser.IAP do
  @moduledoc false

  alias ReceiptDecoder.Util
  alias ReceiptDecoder.IAPReceipt

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
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:quantity, v |> :crypto.bytes_to_integer()}
  end

  defp do_parse({:InAppAttribute, 1702, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:product_id, v}
  end

  defp do_parse({:InAppAttribute, 1703, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:transaction_id, v}
  end

  defp do_parse({:InAppAttribute, 1704, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:purchase_date, Util.format_datetime(v)}
  end

  defp do_parse({:InAppAttribute, 1705, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:original_transaction_id, v}
  end

  defp do_parse({:InAppAttribute, 1706, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:original_purchase_date, Util.format_datetime(v)}
  end

  defp do_parse({:InAppAttribute, 1708, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:expires_date, Util.format_datetime(v)}
  end

  defp do_parse({:InAppAttribute, 1711, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:web_order_line_item_id, v |> :crypto.bytes_to_integer()}
  end

  defp do_parse({:InAppAttribute, 1712, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:cancellation_date, Util.format_datetime(v)}
  end

  defp do_parse({:InAppAttribute, 1719, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:is_in_intro_offer_period, v |> :crypto.bytes_to_integer()}
  end

  defp do_parse({:InAppAttribute, type, version, value}) do
    {:unknown, %{type: type, version: version, value: value}}
  end
end

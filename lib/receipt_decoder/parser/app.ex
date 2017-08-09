defmodule ReceiptDecoder.Parser.App do
  alias ReceiptDecoder.Parser.IAP
  alias ReceiptDecoder.Util

  def parse(data) do
    data
    |> Enum.map(&do_parse/1)
    |> Enum.reject(fn {field, _} -> match?(:unknown, field) end)
  end

  defp do_parse({:ReceiptAttribute, 0, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:environment, v}
  end
  defp do_parse({:ReceiptAttribute, 2, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:bundle_id, v}
  end
  defp do_parse({:ReceiptAttribute, 3, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:application_version, v}
  end
  defp do_parse({:ReceiptAttribute, 4, _version, value}) do
    {:opaque_value, value}
  end
  defp do_parse({:ReceiptAttribute, 5, _version, value}) do
    {:sha1_hash, value}
  end
  defp do_parse({:ReceiptAttribute, 17, _version, value}) do
    {:ok, data} = :ReceiptModule.decode(:InAppReceipt, value)
    {:in_app, IAP.parse(data)}
  end
  defp do_parse({:ReceiptAttribute, 19, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:original_application_version, v}
  end
  defp do_parse({:ReceiptAttribute, 12, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:creation_date, Util.format_datetime(v)}
  end
  defp do_parse({:ReceiptAttribute, 21, _version, value}) do
    <<_::bytes-size(1), len::integer-size(8), v::bytes-size(len)>> = value

    {:expiration_date, Util.format_datetime(v)}
  end
  defp do_parse({:ReceiptAttribute, type, version, value}) do
    {:unknown, %{type: type, version: version, value: value}}
  end
end

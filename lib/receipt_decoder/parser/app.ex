defmodule ReceiptDecoder.Parser.App do
  @moduledoc false

  alias ReceiptDecoder.Parser.IAP
  alias ReceiptDecoder.AppReceipt
  alias ReceiptDecoder.Parser.Helper

  @spec parse(keyword) :: AppReceipt.t()
  def parse(data) do
    attrs =
      data
      |> Enum.map(&do_parse/1)
      |> Enum.reject(fn {field, _} -> match?(:unknown, field) end)
      |> into_map()

    struct(AppReceipt, attrs)
  end

  defp do_parse({:ReceiptAttribute, 0, _version, value}) do
    {:environment, Helper.extract_string(value)}
  end

  defp do_parse({:ReceiptAttribute, 2, _version, value}) do
    {:bundle_id, Helper.extract_string(value)}
  end

  defp do_parse({:ReceiptAttribute, 3, _version, value}) do
    {:application_version, Helper.extract_string(value)}
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
    {:original_application_version, Helper.extract_string(value)}
  end

  defp do_parse({:ReceiptAttribute, 12, _version, value}) do
    {:creation_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:ReceiptAttribute, 21, _version, value}) do
    {:expiration_date, Helper.extract_datetime(value)}
  end

  defp do_parse({:ReceiptAttribute, type, version, value}) do
    {:unknown, %{type: type, version: version, value: value}}
  end

  defp into_map(keyword_list) do
    keyword_list
    |> Keyword.delete(:in_app)
    |> Enum.into(%{})
    |> Map.merge(%{in_apps: Keyword.get_values(keyword_list, :in_app)})
  end
end

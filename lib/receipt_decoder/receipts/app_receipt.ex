defmodule ReceiptDecoder.AppReceipt do
  @moduledoc """
  The struct represent an App Receipt
  """

  defstruct environment: nil,
            bundle_id: nil,
            application_version: nil,
            opaque_value: nil,
            sha1_hash: nil,
            in_apps: [],
            original_application_version: nil,
            creation_date: nil,
            expiration_date: nil

  @type t :: %__MODULE__{
          environment: String.t(),
          bundle_id: String.t(),
          application_version: String.t(),
          opaque_value: String.t(),
          sha1_hash: String.t(),
          in_apps: [ReceiptDecoder.IAPReceipt.t()],
          original_application_version: String.t(),
          creation_date: NaiveDateTime.t(),
          expiration_date: NaiveDateTime.t()
        }
end

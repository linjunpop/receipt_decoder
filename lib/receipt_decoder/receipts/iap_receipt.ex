defmodule ReceiptDecoder.IAPReceipt do
  @moduledoc """
  The struct represent an In-App Purchases Receipt
  """

  defstruct quantity: nil,
            product_id: nil,
            transaction_id: nil,
            purchase_date: nil,
            original_transaction_id: nil,
            original_purchase_date: nil,
            expires_date: nil,
            web_order_line_item_id: nil,
            cancellation_date: nil

  @type t :: %__MODULE__{
          quantity: non_neg_integer,
          product_id: String.t(),
          transaction_id: String.t(),
          purchase_date: NaiveDateTime.t(),
          original_transaction_id: String.t(),
          original_purchase_date: NaiveDateTime.t(),
          expires_date: NaiveDateTime.t(),
          web_order_line_item_id: pos_integer,
          cancellation_date: NaiveDateTime.t()
        }
end

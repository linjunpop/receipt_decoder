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
            cancellation_date: nil,
            is_in_intro_offer_period: nil

  @type t :: %__MODULE__{
          quantity: non_neg_integer,
          product_id: String.t(),
          transaction_id: String.t(),
          purchase_date: DateTime.t(),
          original_transaction_id: String.t(),
          original_purchase_date: DateTime.t(),
          expires_date: DateTime.t(),
          web_order_line_item_id: pos_integer,
          cancellation_date: DateTime.t(),
          is_in_intro_offer_period: integer()
        }
end

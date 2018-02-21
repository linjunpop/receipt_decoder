# CHANGELOG

## master

* Added `ReceiptDecoder.Verifier` to verify the the receipt,
  this would let a invalid receipt failed to decode.
* Added new `is_in_intro_offer_period` field to IAP receipt.
* Drop support for Elixir 1.3.
* Returns `{:error, msg}` for invalid receipt.

## v0.2.0

* Parse result as `ReceiptDecoder.AppReceipt` & `ReceiptDecoder.IAPReceipt`.

## v0.1.0

* Initial release

# CHANGELOG

## master

- Regenerate the `ReceiptModule` with `:asn1` 5.0.9.
- Update minimal requirement to Erlang 21.

## v0.4.0

- Fixes the date fields in receipt should be parsed as a `DateTime` in UTC.
- Drop Support for Elixir 1.4 and 1.5.

## v0.3.0

- Added `ReceiptDecoder.Verifier` to verify the the receipt,
  this would let a invalid receipt failed to decode.
- Added new `is_in_intro_offer_period` field to IAP receipt.
- Drop support for Elixir 1.3.
- Returns `{:error, msg}` for invalid receipt.

## v0.2.0

- Parse result as `ReceiptDecoder.AppReceipt` & `ReceiptDecoder.IAPReceipt`.

## v0.1.0

- Initial release

# ReceiptDecoder

Decode iOS App receipt

[![Build Status](https://travis-ci.org/linjunpop/receipt_decoder.svg?branch=master)](https://travis-ci.org/linjunpop/receipt_decoder)
[![codebeat badge](https://codebeat.co/badges/55bc18a1-1ea8-4dda-b844-7e534c24fc66)](https://codebeat.co/projects/github-com-linjunpop-receipt_decoder-master)
[![Hex.pm](https://img.shields.io/hexpm/v/receipt_decoder.svg?maxAge=2592000)](https://hex.pm/packages/receipt_decoder)

## Installation

The package can be installed by adding `receipt_decoder` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:receipt_decoder, "~> 0.3.0"}
  ]
end
```

## Usage

```elixir
ReceiptDecoder.decode(BASE64_ENCODED_RECEIPT)
# {:ok, %ReceiptDecoder.AppReceipt{...}}
```

Please view the detailed documentation at [https://hexdocs.pm/receipt_decoder](https://hexdocs.pm/receipt_decoder).

Or see it in action: [http://receipt-viewer.linjun.me](http://receipt-viewer.linjun.me)

## Changes

See [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/linjunpop/receipt_decoder.

## See also

- [ReceiptVerifier](https://github.com/linjunpop/receipt_verifier) - verify the receipt with App Store

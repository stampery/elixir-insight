# Insight

Elixir package for consuming any [Insight](https://insight.is/)-powered Bitcoin explorer.

## Installation

  1. Add insight to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [{:insight, "~> 0.0.1"}]
end
```
  2. Ensure insight is started before your application:
```elixir
def application do
  [applications: [:insight]]
end
```
## Usage

### Using default BitPay's livenet explorer
```elixir
defmodule Mymodule do
  use Insight

  def my_function do
    # Getting unspent transaction outputs
    bitcoin_address = "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"
    utxos = get_utxos(bitcoin_address)

    # Broadcasting a signed transaction
    signed = "01000000017b1eabe0209b1fe794124575ef807057c77ada2138ae4fa8d6c4de0398a14f3f00000000494830450221008949f0cb400094ad2b5eb399d59d01c14d73d8fe6e96df1a7150deb388ab8935022079656090d7f6bac4c9a94e0aad311a4268e082a725f8aeae0573fb12ff866a5f01ffffffff01f0ca052a010000001976a914cbc20a7664f2f69e5355aa427045bc15e7c6c77288ac00000000"
    tx = broadcast(signed)
  end

end
```
### Using a custom explorer
```elixir
defmodule Mymodule do
  use Insight, "https://search.bitaccess.ca/api/"

  [...]
end
```
### Some compatible API endpoints available out there

**Livenet**

+ BitAccess livenet: [https://search.bitaccess.ca/api/]
+ Localbitcoins livenet: [https://chain.localbitcoins.com/api/]
+ BlockExplorer livenet: [https://blockexplorer.com/api/]
+ DigiExplorer livenet: [http://digiexplorer.info/api/]
+ ExploreBTCD livenet: [http://explorebtcd.info/api/]

**Testnet**

+ BitPay testnet: [https://test-insight.bitpay.com/api/]
+ BlockExplorer testnet: [https://testnet.blockexplorer.com/api/]


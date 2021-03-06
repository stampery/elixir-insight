defmodule Insight do

  defmodule Utxo do
    defstruct [ :txid, :vout, :address, :script, :satoshis ]
  end

  defmodule Tx do
    defstruct [ :addresses, :block_height, :block_index, :confidence,
                :confirmations, :data_protocol, :double_spend, :fees, :hash,
                :inputs, :lock_time, :outputs, :preference, :received,
                :relayed_by, :size, :total, :ver, :vin_sz, :vout_sz ]
  end

  defmacro __using__(endpoint) when is_binary(endpoint) do
    quote do
      require Logger

      @endpoint unquote endpoint

      def get_utxos address do
        request = HTTPoison.get("#{@endpoint}addr/#{address}/utxo", [], params: %{noCache: 1})
        case request do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            txrefs = Poison.decode! body
            utxos = Enum.map txrefs, fn tx -> %Utxo{
              txid: tx["txid"],
              vout: tx["vout"],
              address: address,
              script: tx["scriptPubKey"],
              satoshis: round(tx["amount"] * 100000000)
            } end
            Logger.info "[Insight][UTXO] OK #{inspect Enum.count utxos}"
            {:ok, utxos}
          {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
            Logger.error "[Insight][UTXO] HTTP error #{inspect %{status_code: status, body: body}}"
            {:error, {status, body}}
          {:error, %HTTPoison.Error{reason: reason}} ->
            Logger.error "[Insight][UTXO] HTTPoison error #{inspect %{reason: reason}}"
            {:error, reason}
        end
      end

      def broadcast signed do
        request = HTTPoison.post("#{@endpoint}tx/send", {:form, [rawtx: signed]})
        case request do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            tx = %Tx{hash: (Poison.decode!(body))["txid"]}
            Logger.info "[Insight][TX] OK #{inspect tx}"
            {:ok, tx}
          {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
            Logger.error "[Insight][TX] HTTP error #{inspect %{status_code: status, body: body}}"
            {:error, {status, body}}
          {:error, %HTTPoison.Error{reason: reason}} ->
            Logger.error "[Insight][TX] HTTPoison error #{inspect %{reason: reason}}"
            {:error, reason}
        end
      end

      defp map_atomize map do
        Map.new Enum.map map, fn {key, val} -> {String.to_atom(key), val} end
      end

    end
  end

  defmacro __using__(args) when is_list(args) do
    quote do
      Insight.__using__ "https://insight.bitpay.com/api/"
    end
  end

end

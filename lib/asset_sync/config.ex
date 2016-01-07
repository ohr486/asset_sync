defmodule AssetSync.Config do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :asset_sync)
  end

  def cache(key) do
    case :ets.lookup(__MODULE__, key) do
      [{key, val}] -> val
      [] ->
        val = fetch(key)
        case val do
          :undefined -> nil
          _ ->
            :ets.insert(__MODULE__, {key, val})
            val
        end
    end
  end

  def fetch(key) do
    case key do
      :newest_asset -> AssetSync.Storage.S3.newest_asset!
      :target_asset_dir -> AssetSync.target_asset_dir
      :asset_host -> AssetSync.asset_host
      :enable -> enable
      _ -> :undefined
    end
  end

  # --- callbacks ---

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true])
    :ets.insert(__MODULE__, [__config__: self()])
    {:ok, :var}
  end

  def handle_call(_,_,_) do
    {:reply, :ok, :var}
  end

  # --- configurations ---

  def enable do
    Application.get_env(:asset_sync, :enable)
  end
end

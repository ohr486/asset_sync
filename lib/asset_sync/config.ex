defmodule AssetSync.Config do
  use GenServer

  # TODO: test it
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :asset_sync_config)
  end

  # TODO: test it
  def init([]) do
    table = :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true])
    :ets.insert(__MODULE__, [__config__: self()])
    {:ok, table}
  end

  # TODO: refactor it
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

  # TODO: test it
  def fetch(key) do
    case key do
      :asset_ver -> AssetSync.Config.asset_ver
      :newest_asset -> AssetSync.Config.storage.newest_asset!
      :target_asset_dir -> AssetSync.Config.target_asset_dir
      :asset_host -> AssetSync.Config.asset_host
      :enable -> AssetSync.Config.enable
      _ -> :undefined
    end
  end

  # --- storage ---

  def storage do
    case Application.get_env(:asset_sync, :storage) do
      :s3 -> AssetSync.Storage.S3
      _ -> raise "set asset_sync config for storage" # TODO: define custom error
    end
  end

  # --- configurations ---

  def enable do
    Application.get_env(:asset_sync, :enable) || false
  end

  def asset_prefix do
    Application.get_env(:asset_sync, :asset_prefix) || "asset-"
  end

  def asset_keep do
    Application.get_env(:asset_sync, :asset_keep) || 5
  end

  def asset_ver do
    Application.get_env(:asset_sync, :asset_ver)
  end

  def target_asset_dir do
    # TODO: define custom error
    Application.get_env(:asset_sync, :target_asset_dir) || raise "[asset_sync] set target_asset_dir!"
  end

  def asset_host do
    # TODO: define custom error
    Application.get_env(:asset_sync, :asset_host) || raise "[asset_sync] set asset_host!"
  end

  # --- aws config ---

  def region do
    Application.get_env(:asset_sync, :region) || Application.get_env(:ex_aws, :region) || "us-east-1"
  end

  def bucket do
    # TODO: define custom error
    Application.get_env(:asset_sync, :bucket) || raise "[asset_sync] set bucket!"
  end
end

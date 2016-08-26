defmodule AssetSync.ConfigTest do
  use ExUnit.Case, async: true

  setup do
    on_exit fn ->
      :meck.unload(Application)
    end
  end

  # --- start_link/0 ---

  # --- cache/1 ---

  # --- fetch/1 ---

  # --- init/1 ---

  # --- handle_call/3 ---

  # --- storage/0 ---

  test "storage/0 # if (:asset_sync, :storage) is S3, return S3 module." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :storage) -> :s3 end)
    assert AssetSync.Config.storage == AssetSync.Storage.S3
  end

  # TODO: define custom error mod
  test "storage/0 # if env does not exist, raise error." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :storage) -> nil end)
    assert_raise RuntimeError, fn -> AssetSync.Config.storage end
  end

  # --- enable/0 ---

  test "enable/0 # return (:asset_sync, :enable) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :enable) -> :enable_val end)
    assert AssetSync.Config.enable == :enable_val
  end

  # TODO: define custom error mod
  test "enable/0 # if env does not exist, return false." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :enable) -> nil end)
    assert AssetSync.Config.enable == false
  end

  # --- asset_prefix/0 ---

  test "asset_prefix/0 # return (:asset_sync, :asset_prefix) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_prefix) -> :asset_prefix_val end)
    assert AssetSync.Config.asset_prefix == :asset_prefix_val
  end

  test "asset_prefix/0 # if env does not exist, return asset-." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_prefix) -> nil end)
    assert AssetSync.Config.asset_prefix == "asset-"
  end

  # --- asset_keep/0 ---

  test "asset_keep/0 # return (:asset_sync, :asset_keep) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_keep) -> :asset_keep_val end)
    assert AssetSync.Config.asset_keep == :asset_keep_val
  end

  test "asset_keep/0 # if env does not exist, return 5." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_keep) -> nil end)
    assert AssetSync.Config.asset_keep == 5
  end

  # --- asset_ver/0 ---

  test "asset_ver/0 # return (:asset_sync, :asset_ver) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_ver) -> :asset_ver_val end)
    assert AssetSync.Config.asset_ver == :asset_ver_val
  end

  test "asset_ver/0 # if env does not exit, return nil." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_ver) -> nil end)
    assert AssetSync.Config.asset_ver == nil
  end

  # --- target_asset_dir/0 ---

  test "target_asset_dir/0 # return (:asset_sync, :target_asset_dir) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :target_asset_dir) -> :target_asset_dir_val end)
    assert AssetSync.Config.target_asset_dir == :target_asset_dir_val
  end

  # TODO: define custom error mod
  test "target_asset_dir/0 # if env does not exist, raise error." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :target_asset_dir) -> nil end)
    assert_raise RuntimeError, fn -> AssetSync.Config.target_asset_dir end
  end

  # --- asset_host/0 ---

  test "asset_host/0 # return (:asset_sync, :asset_host) env." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_host) -> :asset_host_val end)
    assert AssetSync.Config.asset_host == :asset_host_val
  end

  # TODO: define custom error mod
  test "target_host/0 # if env does not exist, raise error." do
    :meck.expect(Application, :get_env, fn(:asset_sync, :asset_host) -> nil end)
    assert_raise RuntimeError, fn -> AssetSync.Config.asset_host end
  end
end

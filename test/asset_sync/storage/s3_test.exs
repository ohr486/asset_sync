defmodule AssetSync.Storage.S3Test do
  use ExUnit.Case, async: true

  setup do
    on_exit fn -> :meck.unload(AssetSync.Storage.S3) end
    :ok
  end

  # --- asset_list!/1 ---

  test "asset_list!/1 # if no data exists, return blank." do
    req_body = %{body: %{contents: []}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.asset_list!([]) == []
  end

  test "asset_list!/1 # if no data matches, return blank." do
    ele1 = %{key: "hoo"}
    ele2 = %{key: "var"}
    req_body = %{body: %{contents: [ele1, ele2]}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.asset_list!([]) == []
  end

  test "asset_list!/1 # return matched key name and ordered list." do
    ele1 = %{key: "ele1"}
    ele2 = %{key: "ele2/"}
    ele3 = %{key: "ele3"}
    ele4 = %{key: "ele4/"}
    ele5 = %{key: "ele5/ele5-1"}
    ele6 = %{key: "ele6/ele6-1/"}
    ele7 = %{key: "ele7/ele7-1/ele7-2"}
    ele8 = %{key: "ele8/ele8-1/ele8-2/"}
    req_body = %{body: %{contents: [ele1, ele2, ele3, ele4, ele5, ele6, ele7, ele8]}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.asset_list!([]) == ["ele4", "ele2"]
  end

  test "assetlist!/1 # if response is invalid, raise error." do
    req_body = %{body: %{hoo: []}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert_raise RuntimeError, fn -> AssetSync.Storage.S3.asset_list!([]) end
  end

  # --- newest_asset!/1 ---

  test "newest_asset!/1 # if no data exists, return nil." do
    req_body = %{body: %{contents: []}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.newest_asset!([]) == nil
  end

  test "newest_asset!/1 # if no data matches, return nil." do
    ele1 = %{key: "ele1"}
    ele2 = %{key: "ele2"}
    req_body = %{body: %{contents: [ele1, ele2]}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.newest_asset!([]) == nil
  end

  test "newest_asset!/1 # return matched and newest asset name." do
    ele1 = %{key: "ele1"}
    ele2 = %{key: "ele2/"}
    ele3 = %{key: "ele3"}
    ele4 = %{key: "ele4/"}
    req_body = %{body: %{contents: [ele1, ele2, ele3, ele4]}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    assert AssetSync.Storage.S3.newest_asset!([]) == "ele4"
  end

  # --- create_asset_dir!/2 ---

  test "create_asset_dir!/2" do
    :meck.expect(AssetSync.Storage.S3, :put_object!, fn("asset-ver/", "", [opt_key: :opt_val]) -> :ok end)
    assert AssetSync.Storage.S3.create_asset_dir!("asset-ver", [opt_key: :opt_val]) == :ok
  end

  test "create_asset_dir!/1" do
    :meck.expect(AssetSync.Storage.S3, :put_object!, fn("asset-ver/", "", []) -> :ok end)
    assert AssetSync.Storage.S3.create_asset_dir!("asset-ver") == :ok
  end

  # --- delete_asset!/2 ---

  test "delete_asset!/2" do
    ele1 = %{key: "ver1"}
    ele2 = %{key: "ver1/"}
    ele3 = %{key: "ver1/ele1"}
    ele4 = %{key: "ver1/ele1/"}
    ele5 = %{key: "ver1/ele2/"}
    ele6 = %{key: "ver1/ele2/ele3"}
    ele7 = %{key: "ver1/ele2/ele3/"}
    ele8 = %{key: "ver2/"}
    ele9 = %{key: "ver2/ele4"}
    req_body = %{body: %{contents: [ele1, ele2, ele3, ele4, ele5, ele6, ele7, ele8, ele9]}}
    :meck.expect(AssetSync.Storage.S3, :get_object_data!, fn([]) -> req_body end)
    :meck.expect(AssetSync.Storage.S3, :delete_object!, [
      {["ver1/",           []], :ok},
      {["ver1/ele1",       []], :ok},
      {["ver1/ele1/",      []], :ok},
      {["ver1/ele2/",      []], :ok},
      {["ver1/ele2/ele3",  []], :ok},
      {["ver1/ele2/ele3/", []], :ok}
    ])

    assert AssetSync.Storage.S3.delete_asset!("ver1", []) == :ok
  end

  # --- put_object!/3 ---

  test "put_object!/3" do
    _expected_req = %ExAws.Operation.S3{
      bucket: "test-bucket",
      path: "path/to/put/obj",
      body: "dummy-data",
      headers: %{}, http_method: :put, params: %{},
      parser: &ExAws.Utils.identity/1,
      resource: "", service: :s3, stream_builder: nil
    }
    :meck.expect(AssetSync.Storage.S3, :exec_operation, fn(_expected_req) -> :ok end)
    assert AssetSync.Storage.S3.put_object!("path/to/put/obj", "dummy-data", []) == :ok
  end

  test "put_object!/2" do
    _expected_req = %ExAws.Operation.S3{
      bucket: "test-bucket",
      path: "path/to/put/obj",
      body: "dummy-data",
      headers: %{}, http_method: :put, params: %{},
      parser: &ExAws.Utils.identity/1,
      resource: "", service: :s3, stream_builder: nil
    }
    :meck.expect(AssetSync.Storage.S3, :exec_operation, fn(_expected_req) -> :ok end)
    assert AssetSync.Storage.S3.put_object!("path/to/put/obj", "dummy-data") == :ok
  end

  # --- delete_object!/2 ---

  test "delete_object!/2" do
    _expected_req = %ExAws.Operation.S3{
      bucket: "bucket",
      path: "/path/to/del/obj",
      body: "",
      headers: %{}, http_method: :delete, params: %{},
      parser: &ExAws.Utils.identity/1,
      resource: "", service: :s3, stream_builder: nil
    }
    :meck.expect(AssetSync.Storage.S3, :exec_operation, fn(_expected_req) -> :ok end)
    assert AssetSync.Storage.S3.delete_object!("path/to/put/obj", []) == :ok
  end

  test "delete_object!/1" do
    _expected_req = %ExAws.Operation.S3{
      bucket: "bucket",
      path: "/path/to/del/obj",
      body: "",
      headers: %{}, http_method: :delete, params: %{},
      parser: &ExAws.Utils.identity/1,
      resource: "", service: :s3, stream_builder: nil
    }
    :meck.expect(AssetSync.Storage.S3, :exec_operation, fn(_expected_req) -> :ok end)
    assert AssetSync.Storage.S3.delete_object!("path/to/put/obj") == :ok
  end

  # --- asset_url!/1 ---

end

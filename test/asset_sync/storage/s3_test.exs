defmodule AssetSync.Storage.S3Test do
  use PowerAssert, async: true
  #use ExUnit.Case, async: true

  setup do
    Application.put_env(:ex_aws, :access_key_id, "AWS_A_KEY")
    Application.put_env(:ex_aws, :secret_access_key, "AWS_S_KEY")

    Application.put_env(:asset_sync, :bucket, "test-bucket")

    on_exit fn ->
      Application.delete_env(:ex_aws, :region)
      Application.delete_env(:ex_aws, :access_key_id)
      Application.delete_env(:ex_aws, :secret_access_key)

      Application.delete_env(:asset_sync, :region)
      Application.delete_env(:asset_sync, :asset_prefix)
    end

    :ok
  end


  # --- client/0 ---
  test "client(default settings)" do
    client = AssetSync.Storage.S3.client
    assert client.service == :s3
    assert client.__struct__ == ExAws.S3
    assert client.config.access_key_id == "AWS_A_KEY"
    assert client.config.secret_access_key == "AWS_S_KEY"
    assert client.config.region == "us-east-1"
  end

  test "client(ex_aws config settings)" do
    Application.put_env(:ex_aws, :access_key_id, "ex-aws-a-key")
    Application.put_env(:ex_aws, :secret_access_key, "ex-aws-s-key")
    Application.put_env(:ex_aws, :region, "sa-east-1")

    client = AssetSync.Storage.S3.client
    assert client.service == :s3
    assert client.__struct__ == ExAws.S3
    assert client.config.access_key_id == "ex-aws-a-key"
    assert client.config.secret_access_key == "ex-aws-s-key"
    assert client.config.region == "sa-east-1"
  end

  test "client(asset_sync config settings)" do
    Application.put_env(:ex_aws, :access_key_id, "ex-aws-a-key")
    Application.put_env(:ex_aws, :secret_access_key, "ex-aws-s-key")
    Application.put_env(:ex_aws, :region, "sa-east-1")
    Application.put_env(:asset_sync, :region, "eu-west-1")

    client = AssetSync.Storage.S3.client
    assert client.service == :s3
    assert client.__struct__ == ExAws.S3
    assert client.config.access_key_id == "ex-aws-a-key"
    assert client.config.secret_access_key == "ex-aws-s-key"
    assert client.config.region == "eu-west-1"
  end

  # --- region/0 ---
  test "region(default value)" do
    assert AssetSync.Storage.S3.region == "us-east-1"
  end

  test "region(ex_aws config value)" do
    Application.put_env(:ex_aws, :region, "ex-aws-region")
    assert AssetSync.Storage.S3.region == "ex-aws-region"
  end

  test "region(asset_sync config value)" do
    Application.put_env(:asset_sync, :region, "asset-sync-region")
    Application.put_env(:ex_aws, :region, "ex-aws-region")
    assert AssetSync.Storage.S3.region == "asset-sync-region"
  end

  # --- bucket/0 ---
  test "bucket" do
    assert AssetSync.Storage.S3.bucket == "test-bucket"
  end

  # --- asset_prefix/0 ---
  test "asset_prefix(default value)" do
    assert AssetSync.Storage.S3.asset_prefix == "asset-"
  end

  test "asset_prefix(config value)" do
    Application.put_env(:asset_sync, :asset_prefix, "asset-sync-prefix-")
    assert AssetSync.Storage.S3.asset_prefix == "asset-sync-prefix-"
  end
end

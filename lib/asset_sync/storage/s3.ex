defmodule AssetSync.Storage.S3 do
  @behaviour AssetSync.Storage

  alias ExAws.S3
  alias ExAws.S3.Impl, as: S3Impl

  # --- asset ---

  # TODO: test it
  def get_assets!(opts \\ []) do
    client
    |> S3Impl.list_objects!(bucket, opts)
    |> Map.fetch!(:body)
    |> Map.fetch!(:contents)
    |> Enum.filter(&String.match?(&1.key, ~r/^[^\/]*\/$/))
  end

  # I/F
  # TODO: test it
  def list_assets!(opts \\ []) do
    get_assets!(opts)
    |> Enum.map(&Map.fetch!(&1, :key))
    |> Enum.sort(&(&1 > &2))
  end
 
  # I/F
  # TODO: test it
  def newest_asset!(opts \\ []) do
    case get_assets!(opts) do
      [] -> nil
      assets -> Enum.max_by(assets, &Map.fetch!(&1, :key))[:key]
    end
  end

  # I/F
  # TODO: test it
  def create_asset_dir!(asset_ver, opts \\ []) do
    client
    |> S3Impl.put_object!(bucket, "#{asset_ver}/", "")
  end

  # I/F
  # TODO: test it
  def delete_asset!(asset_ver, opts \\ []) do
    list_asset_files!(asset_ver, opts) |> Enum.each(&delete_object!(&1, opts))
    list_asset_dirs!(asset_ver, opts) |> Enum.each(&delete_object!(&1, opts))
    delete_object!("#{asset_ver}/", opts)
  end


  # --- asset objects ---

  # TODO: test it
  def get_asset_objects!(asset_ver, opts \\ []) do
    client
    |> S3Impl.list_objects!(bucket, opts) # TODO: pre filter
    |> Map.fetch!(:body)
    |> Map.fetch!(:contents)
  end

  # TODO: test it
  def list_asset_objects!(asset_ver, opts \\ []) do
    get_asset_objects!(asset_ver, opts)
    |> Enum.map(&Map.fetch!(&1, :key))
  end

  # TODO: test it
  def list_asset_files!(asset_ver, opts \\ []) do
    list_asset_objects!(asset_ver, opts)
    |> Enum.reject(&String.ends_with?(&1, "/"))
    |> Enum.filter(&String.starts_with?(&1, "#{asset_ver}"))
  end

  # TODO: test it
  def list_asset_dirs!(asset_ver, opts \\ []) do
    list_asset_objects!(asset_ver, opts)
    |> Enum.filter(&String.ends_with?(&1, "/"))
    |> Enum.filter(&String.starts_with?(&1, "#{asset_ver}"))
  end

  # TODO: test it
  def put_asset_object!(asset_ver, asset_path, data, opts \\ []) do
    path = "#{asset_ver}/#{asset_path}"
    put_object!(path, data, opts)
  end

  # --- object ---

  # TODO: test it
  def put_object!(path, data, opts \\ []) do
    client
    |> S3Impl.put_object!(bucket, "#{path}", data, opts)
  end

  # TODO: test it
  def delete_object!(path, opts \\ []) do
    client
    |> S3Impl.delete_object!(bucket, path, opts)
  end

  # --- URL ---
  def asset_url(path) do
    newest_asset = AssetSync.Config.cache(:newest_asset)
    target_asset_dir = AssetSync.Config.cache(:target_asset_dir)
    AssetSync.Config.cache(:asset_host) <> "/" <> newest_asset <> target_asset_dir <> path
  end

  # --- private ---

  def client do
    S3.new(region: region)
  end

  # TODO: Configに委譲

  def region do
    Application.get_env(:asset_sync, :region) || Application.get_env(:ex_aws, :region) || "us-east-1"
  end

  def bucket do
    Application.get_env(:asset_sync, :bucket)
  end

end

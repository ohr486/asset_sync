defmodule AssetSync.Storage.S3 do
  @moduledoc """
  """

  @behaviour AssetSync.Storage

  # --- handle asset ---

  @doc "Show asset name list"
  def asset_list!(opts \\ []) do
    AssetSync.Storage.S3.get_object_data!(opts)
    |> object_data_to_object_list
    |> object_list_to_assets
    |> Enum.sort(&(&1 > &2))
  end

  @doc "Return newest asset name"
  def newest_asset!(opts \\ []) do
    case asset_list!(opts) do
      [] -> nil
      list -> Enum.max(list)
    end
  end

  @doc "Create asset dir"
  def create_asset_dir!(asset_ver, opts \\ []) do
    AssetSync.Storage.S3.put_object!("#{asset_ver}/", "", opts)
  end

  @doc "Delete asset files and dirs"
  def delete_asset!(asset_ver, opts \\ []) do
    object_list = AssetSync.Storage.S3.get_object_data!(opts)
                  |> object_data_to_object_list
                  |> filter_by_asset_ver(asset_ver)
                  |> Enum.reject(&String.equivalent?(&1, "#{asset_ver}/"))

    object_list
    |> object_list_to_files
    |> Enum.each(&AssetSync.Storage.S3.delete_object!(&1, opts))

    object_list
    |> object_list_to_dirs
    |> Enum.each(&AssetSync.Storage.S3.delete_object!(&1, opts))

    AssetSync.Storage.S3.delete_object!("#{asset_ver}/", opts)
  end

  # --- handle object ---

  @doc "Put object to asset dir"
  def put_object!(path, data, opts \\ []) do
    ExAws.S3.put_object(AssetSync.Config.bucket, "#{path}", data, opts)
    |> AssetSync.Storage.S3.exec_operation
  end

  @doc "Delete object from asset dir"
  def delete_object!(path, opts \\ []) do
    ExAws.S3.delete_object(AssetSync.Config.bucket, path, opts)
    |> AssetSync.Storage.S3.exec_operation
  end

  # TODO: test it
  def get_object_data!(opts \\ []) do
    bucket = AssetSync.Config.bucket
    ope = ExAws.S3.list_objects(bucket, opts)

    case AssetSync.Storage.S3.exec_operation(ope) do
      {:ok, body} -> body
      _ -> raise "list_object error for #{bucket} bucket."
    end
  end

  # TODO: test it
  def exec_operation(ope) do
    ExAws.request(ope)
  end

  defp object_data_to_object_list(%{body: %{contents: object_list}}) do
    object_list
    |> Enum.map(&Map.fetch!(&1, :key))
  end
  defp object_data_to_object_list(_), do: raise "invalid list_object response."

  defp object_list_to_assets(object_list) do
    object_list
    |> Enum.filter(&String.match?(&1, ~r/^[^\/]*\/$/))
    |> Enum.map(&String.replace_suffix(&1, "/", ""))
  end

  defp filter_by_asset_ver(object_list, asset_ver) do
    object_list
    |> Enum.filter(&String.starts_with?(&1, "#{asset_ver}/"))
  end

  defp object_list_to_files(object_list) do
    object_list
    |> Enum.reject(&String.ends_with?(&1, "/"))
  end

  defp object_list_to_dirs(object_list) do
    object_list
    |> Enum.filter(&String.ends_with?(&1, "/"))
  end

  # --- url path ---

  # TODO: test it
  @doc "Return asset url path"
  def asset_url(path) do
    asset = AssetSync.Config.cache(:asset_ver) || AssetSync.Config.cache(:newest_asset)
    target_asset_dir = AssetSync.Config.cache(:target_asset_dir)
    host = AssetSync.Config.cache(:asset_host)
    host <> "/" <> asset <> "/" <> target_asset_dir <> path
  end
end

defmodule AssetSync do
  use Application
  alias AssetSync.Utils, as: Utils

  def start(_types, _args) do
    AssetSync.Supervisor.start_link
  end

  # use callback api
  # TODO: test it
  def sync do
    asset_ver = asset_prefix <> Utils.current_time_str
    IO.puts "asset_ver: [#{asset_ver}]"
   
    # create asset dir
    storage.create_asset_dir!(asset_ver)
    IO.puts "create_asset_dir!: #{asset_ver}"

    # sync target asset dir
    target = target_asset_dir
    IO.puts "target_dir: #{inspect target}"

    upload_dir!(asset_ver, target)
  end

  # use callback api
  # TODO: test it
  def cleanup do
    asset_list = storage.list_assets!
    count = Enum.count(asset_list)
    keep = asset_keep

    IO.puts "total asset count: #{count}"
    IO.puts "keep asset count:  #{keep}"

    cond do
      (count <= keep) ->
        # do notihg
        nil
      (count > keep) ->
        targets = asset_list |> Enum.take(-(count - keep))
        IO.puts "cleanup targets: #{inspect targets}"
        targets
        |> Enum.each(&delete!(&1))
    end
  end

  # TODO: test it
  def upload_dir!(asset_ver, src_dir_path) do
    IO.puts "upload_dir! : [#{asset_ver}] [#{src_dir_path}]"
    Utils.list_file_paths(src_dir_path)
    |> Enum.each(&upload_file!(asset_ver, &1))
  end

  # use callback api
  # TODO: test it
  def upload_file!(asset_ver, src_file_path) do
    {:ok, file_bin} = File.read(src_file_path)
    file_path = Path.relative_to_cwd(src_file_path) # TODO: rootからの相対パスにする
    content_type = Utils.content_type(file_path)
    IO.puts "upload_file!: [#{asset_ver}]  #{file_path}, content_type: [#{content_type}]"
    storage.put_asset_object!(asset_ver, file_path, file_bin, [content_type: content_type])
  end

  # use callback api
  # TODO: test it
  def delete!(asset_ver) do
    IO.puts "delete!: #{asset_ver}"
    storage.delete_asset!(asset_ver)
  end

  # use callback api
  # TODO: test it
  def asset_url(path) do
    storage.asset_url(path)
  end

  # TODO: Configに委譲
  # --- config ---

  # TODO: test it
  def storage do
    case Application.get_env(:asset_sync, :storage) do
      :s3 -> AssetSync.Storage.S3
      _ -> raise "set asset_sync config for storage" # エラーメッセージのみにする
    end
  end

  # TODO: test it
  def asset_prefix do
    Application.get_env(:asset_sync, :asset_prefix) || "asset-"
  end

  # TODO: test it
  def asset_keep do
    Application.get_env(:asset_sync, :asset_keep) || 5
  end

  # TODO: test it
  def target_asset_dir do
    Application.get_env(:asset_sync, :target_asset_dir)
  end

  # TODO: asset host
  def asset_host do
    Application.get_env(:asset_sync, :asset_host)
  end
end

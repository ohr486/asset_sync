defmodule AssetSync.Cmd do
  alias AssetSync.Utils, as: Utils
  alias AssetSync.Config, as: Config

  # TODO: test it
  def sync do
    asset_ver = Config.asset_prefix <> Utils.current_time_str
    message "asset_ver: [#{asset_ver}]"

    # create asset dir
    Config.storage.create_asset_dir!(asset_ver)
    message "create_asset_dir!: #{asset_ver}"

    # sync target asset dir
    target = Config.target_asset_dir
    message "target_dir: #{inspect target}"
    upload_dir!(asset_ver, target)
  end

  # TODO: test it
  def cleanup do
    asset_list = Config.storage.asset_list!
    count = Enum.count(asset_list)
    keep = Config.asset_keep

    message "total asset count: #{count}"
    message "keep asset count:  #{keep}"

    cond do
      (count <= keep) ->
        nil # do notihg
      (count > keep) ->
        targets = asset_list |> Enum.take(-(count - keep))
        message "cleanup targets: #{inspect targets}"
        targets
        |> Enum.each(&delete!(&1))
    end
  end

  # TODO: test it
  def upload_dir!(asset_ver, src_dir_path) do
    message "upload_dir! : [#{asset_ver}] [#{src_dir_path}]"
    Utils.list_file_paths(src_dir_path)
    |> Enum.each(&upload_file!(asset_ver, &1))
  end

  # TODO: test it
  def upload_file!(asset_ver, src_file_path) do
    {:ok, file_bin} = File.read(src_file_path)
    file_path = Path.relative_to_cwd(src_file_path) # TODO: rootからの相対パスにする
    content_type = Utils.content_type(file_path)
    message "upload_file!: [#{asset_ver}] #{file_path}, content_type: [#{content_type}]"
    Config.storage.put_object!("#{asset_ver}/#{file_path}", file_bin, [content_type: content_type])
  end

  # TODO: test it
  def delete!(asset_ver) do
    message "delete!: #{asset_ver}"
    Config.storage.delete_asset!(asset_ver)
  end

  def message(msg) do
    IO.puts msg
  end
end

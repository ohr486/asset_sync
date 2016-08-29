defmodule AssetSync.Helpers do
  # TODO: test it
  def static_path(conn, path, default_helper_mod) do
    try do
      case AssetSync.Config.cache(:enable) do
        true -> AssetSync.Config.storage.asset_url(path)
        _ -> default_helper_mod.static_path(conn, path)
      end
    rescue
      _ -> default_helper_mod.static_path(conn, path)
    end
  end
end

defmodule AssetSync.Storage do
  use Behaviour

  # --- handle asset ---
  defcallback asset_list!(List.t) :: List.t
  defcallback newest_asset!(List.t) :: Map.t
  defcallback create_asset_dir!(String.t, List.t) :: Map.t
  defcallback delete_asset!(String.t, List.t) :: Map.t

  # --- handle object ---
  defcallback put_object!(String.t, iodata, List.t) :: Map.t
  defcallback delete_object!(String.t, List.t) :: Map.t

  # --- url path ---
  defcallback asset_url(String.t) :: String.t
end

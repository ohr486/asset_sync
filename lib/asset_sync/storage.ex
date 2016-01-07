defmodule AssetSync.Storage do
  use Behaviour

  defcallback list_assets!(List.t) :: List.t
  defcallback newest_asset!(List.t) :: Map.t
  defcallback create_asset_dir!(String.t, List.t) :: Map.t
  defcallback delete_asset!(String.t, List.t) :: Map.t

  defcallback put_object!(String.t, iodata, List.t) :: Map.t
  defcallback delete_object!(String.t, List.t) :: Map.t

  defcallback asset_url(String.t) :: String.t
end

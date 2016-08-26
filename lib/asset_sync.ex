defmodule AssetSync do
  use Application

  def start(_types, _args) do
    {:ok, _pid} = AssetSync.Supervisor.start_link
  end
end

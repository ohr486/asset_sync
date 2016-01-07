defmodule AssetSync.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :asset_sync_sup)
  end

  def init([]) do
    children = [
      worker(AssetSync.Config, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

end

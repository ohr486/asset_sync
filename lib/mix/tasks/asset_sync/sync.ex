defmodule Mix.Tasks.AssetSync.Sync do
  use Mix.Task

  @shortdoc "Sync assets"
  def run(_args) do
    Mix.Task.run "app.start"

    IO.puts "=============================="
    IO.puts "Sync assets starting ..."
    IO.puts "=============================="
    AssetSync.Cmd.sync
    IO.puts "=============================="
    IO.puts "Sync assets completed ..."
    IO.puts "=============================="
  end
end

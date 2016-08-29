defmodule Mix.Tasks.AssetSync.Cleanup do
  use Mix.Task

  @shortdoc "Cleanup assets"
  def run(args) do
    Mix.Task.run "app.start"

    IO.puts "=============================="
    IO.puts "Cleanup assets starting ..."
    IO.puts "=============================="
    AssetSync.Cmd.cleanup
    IO.puts "=============================="
    IO.puts "Cleanup assets completed ..."
    IO.puts "=============================="
  end
end

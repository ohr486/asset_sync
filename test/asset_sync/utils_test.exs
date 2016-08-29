defmodule AssetSync.UtilsTest do
  use ExUnit.Case, async: false

  setup do
    :meck.expect(AssetSync.Utils, :local_time, fn -> {{2015, 1, 2}, {3, 4, 5}} end)

    on_exit fn ->
      :meck.unload(AssetSync.Utils)
    end

    :ok
  end

  # --- list_file_paths/1 ---

  # --- local_time/0 ---

  # --- current_time_str/0 ---

  test "current_time_str/0 # return yyyy-mm-dd-hhmmss" do
    assert AssetSync.Utils.current_time_str == "2015-01-02-030405"
  end

  # --- content_type/1 ---

end

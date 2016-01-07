defmodule AssetSync.UtilsTest do
  use PowerAssert, async: true
  #use ExUnit.Case, async: true

  setup do
    :meck.expect(AssetSync.Utils, :local_time, fn -> {{2015, 1, 2}, {3, 4, 5}} end)

    on_exit fn ->
      :meck.unload(AssetSync.Utils)
    end

    :ok
  end

  test "return yyyy-mm-dd-hhmmss" do
    assert AssetSync.Utils.current_time_str == "2015-01-02-030405"
  end

end

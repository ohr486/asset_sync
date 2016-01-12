defmodule AssetSync.Utils do

  # TODO: test it
  def list_file_paths(path) do
    case File.dir?(path) do
      true ->
        File.ls!(path)
        |> Enum.map(&list_file_paths(path <> "/" <> &1))
        |> List.flatten # TODO: refactor it
      false -> path
    end
  end

  def current_time_str do
    # テスト/mockの為に、AssetSyncUtilsを指定
    now = AssetSync.Utils.local_time
    ymd = now |> elem(0)
    hms = now |> elem(1)
    "#{ymd |> elem(0)}-" <>
    "#{ymd |> elem(1) |> Integer.to_string |> String.rjust(2, ?0)}-" <>
    "#{ymd |> elem(2) |> Integer.to_string |> String.rjust(2, ?0)}-" <>
    "#{hms |> elem(0) |> Integer.to_string |> String.rjust(2, ?0)}" <>
    "#{hms |> elem(1) |> Integer.to_string |> String.rjust(2, ?0)}" <>
    "#{hms |> elem(2) |> Integer.to_string |> String.rjust(2, ?0)}"
  end

  # TODO: test it
  def local_time do
    :calendar.local_time
  end

  # TODO: test it
  def content_type(file_path) do
    file_type = file_path |> String.split(".") |> Enum.take(-1) |> List.first
    case file_type do
      # image
      "gif"  -> "image/gif"
      "jpg"  -> "image/jpeg"
      "jpeg" -> "image/jpeg"
      "png"  -> "image/png"

      # font
      "svg"   -> "image/svg+xml"
      "eot"   -> "application/vnd.ms-fontobject"
      "woff"  -> "application/x-font-woff"
      "woff2" -> "application/x-font-woff2"
      "ttf"   -> "application/x-font-ttf"
      "otf"   -> "application/x-font-otf"

      # js
      "js" -> "text/javascript"

      # css
      "css" -> "text/css"

      # ico
      "ico" -> "image/x-icon"

      # txt
      "txt" -> "text/plain"

      # json
      "json" -> "application/json"

      "html" -> "text/html"
      _ -> "application/octet-stream"
    end
  end

end

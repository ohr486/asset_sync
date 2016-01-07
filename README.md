# asset_sync
asset_sync

## USAGE

### configurations

* add asset_sync and sweet_xml to mix deps

```
defp deps do
  [...,
   {:asset_sync, github: "ohr486/asset_sync", tag: "0.0.1" },
   {:sweet_xml, "~> 0.5", optional: true},
  ]
end
```

* add asset_sync to mix application

```
def application do
  [mod: {YourApp, []},
   applications: [...,
                  :asset_sync
                 ]]
end
```

* add asset_sync and ex_aws settings to config.exs

```
use Mix.Config

config :your_app, YourApp.Endpoint,
  http: ...,
  url: ...,
  #cache_static_manifest: "priv/static/manifest.json", # asset_sync can't handle digest assets yet!
  server: true

config :ex_aws,
  access_key_id: "YOUR_AWS_KEY",
  secret_access_key: "YOUR_SECRET_KEY",
  region: "ap-northeast-1"

config :asset_sync,
  enable: true,
  storage: :s3,
  bucket: "your-asset-bucket",
  target_asset_dir: "priv/static",
  #asset_host: "https://s3-ap-northeast-1.amazonaws.com/british-gadget-production", # if use S3 hosting
  asset_host: "https://xxxxxxxxxxxx.cloudfront.net" # if use CloudFront Hosting

...
```

* override web/web.ex's static_path

```
def view do
  quote do
    ...

    # not use asset_sync(before)
    # import YourApp.Router.Helpers

    # use asset_sync(after)
    # override static_path/2 for asset_sync
    import YourApp.Router.Helpers, except: [static_path: 2]
    def static_path(conn, path) do
      AssetSync.Helpers.static_path(conn, path, YourApp.Router.Helpers)
    end

    ...
  end
end
```

### sync asset files

* upload current asset
```
$ mix asset_sync.sync
```

* cleanup assets
```
$ mix asset_sync.cleanup
```


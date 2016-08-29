# asset\_sync
asset\_sync

## USAGE

### configurations

* add asset\_sync and sweet\_xml to mix deps

```
defp deps do
  [...,
   {:asset_sync, github: "ohr486/asset_sync", tag: "v0.0.2" },
   {:sweet_xml, "~> 0.6", optional: true},
  ]
end
```

* add asset\_sync to mix application

```
def application do
  [mod: {YourApp, []},
   applications: [...,
                  :asset_sync
                 ]]
end
```

* add asset\_sync and ex\_aws settings to config.exs

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
  asset_ver: "asset-yyyy-mm-dd-HHMMSS", # if you select asset version
  #asset_host: "https://s3-ap-northeast-1.amazonaws.com/your-asset-bucket", # if you use S3 hosting
  asset_host: "https://xxxxxxxxxxxx.cloudfront.net" # if you use CloudFront Hosting

...
```

* override web/web.ex's static\_path

```
def view do
  quote do
    ...

    # not use asset_sync(before)
    # import YourApp.Router.Helpers

    # use asset_sync(after)
    # override static_path/2 for asset_sync
    import YourApp.Router.Helpers, except: [static_path: 2]
    def static_path(conn, path), do: AssetSync.Helpers.static_path(conn, path, YourApp.Router.Helpers)

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


use Mix.Config

config :asset_sync,
  enable: true,
  storage: :s3,
  bucket: "test-bucket",
  region: "ap-northeast-1"

config :ex_aws,
  access_key_id: "AWS_A_KEY",
  secret_access_key: "AWS_S_KEY"


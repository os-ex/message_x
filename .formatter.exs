[
  import_deps: [:ecto, :phoenix, :surface, :ash],
  inputs: [".sobelow-conf", "*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]

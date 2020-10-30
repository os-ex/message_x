defmodule MessageX.MixProject do
  use Mix.Project

  def project do
    [
      app: :message_x,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      dialyzer: [
        plt_add_apps: [:phoenix],
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true
      ],
      releases: releases(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  @doc """
  https://www.poeticoding.com/compile-elixir-applications-into-single-executable-binaries-with-bakeware/
  """
  def releases do
    [
      # message_x: [
      #   steps: [:assemble, &Bakeware.assemble/1],
      #   strip_beams: Mix.env() == :prod,
      #   overwrite: true
      # ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MessageX.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.6"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:ecto, "~> 3.5"},
      {:postgrex, ">= 0.0.0"},
      # {:phoenix_live_view, "~> 0.14"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.3 or ~> 0.2.9"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},

      # Ash
      {:ash, "~> 1.20"},
      {:ash_phoenix, "~> 0.1.1"},
      {:ash_postgres, "~> 0.24"},
      # {:ash_json_api, "~> 0.21"},
      # {:ash_graphql, "~> 0.4"},
      # {:ash_policy_authorizer, "~> 0.14"},
      # {:absinthe, "~> 1.5"},
      # {:absinthe_plug, "~> 1.4"},

      # NLP
      {:veritaserum, "~> 0.2.2"},
      {:penelope, "~> 0.4"},
      {:verbnet, "~> 0.3.0"},
      {:corenlp, "~> 0.1.0"},
      {:exwordnet, "~> 0.2.0"},

      # {:text, "~> 0.2.0"},
      # {:flow, "~> 1.0", override: true},

      # Added
      # {:contex, "~> 0.3"},

      # https://github.com/iandwelker/smserver

      # https://codepen.io/adobewordpress/pen/wGGMaV
      # https://codepen.io/fusco/pen/XbpaYv

      {:nimble_parsec, "~> 1.1", override: true},

      # {:exzeitable, "~> 0.4.3"},
      # {:live_props, "~> 0.2.1"},
      # {:uncharted_phoenix, "~> 0.2.0"},
      # {:phoenix_live_view,
      #  [
      #    env: :prod,
      #    git: "https://github.com/phoenixframework/phoenix_live_view.git",
      #    tag: "597c5ddf8af2ca39216a3fe5a44c066774de3abd",
      #    override: true
      #  ]},
      {:phoenix_live_view,
       [
         env: :prod,
         git: "https://github.com/phoenixframework/phoenix_live_view.git",
         tag: "597c5ddf8af2ca39216a3fe5a44c066774de3abd",
         override: true
       ]},
      {:surface, github: "msaraiva/surface", tag: "v0.1.0-rc.1", override: true},
      {:surface_bulma, github: "msaraiva/surface_bulma"},

      # Test
      {:faker, "~> 0.13", only: [:dev, :test]},
      {:ex_machina, "~> 2.4", only: [:dev, :test]},

      # Dark
      {:chat_db, path: "../chat_db"},
      {:applescripts_ex, path: "../applescripts_ex"},
      # {:dark_matter, ">= 1.0.3"},
      # {:dark_ecto, ">= 0.0.0", path: "../../dark-elixir/dark_ecto"},
      {:dark_dev, ">= 1.0.0", only: [:dev, :test], runtime: false}

      # releases
      # {:bakeware, path: "../../common/bakeware", runtime: false},
      # {:bakeware, "~> 0.1", runtime: false},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      # release: ["assets.deploy", "phx.digest", "release"],
      setup: ["deps.get", "ecto.setup", "assets.install"],
      "assets.deploy": ["cmd npm run deploy --prefix assets"],
      "assets.install": ["cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end

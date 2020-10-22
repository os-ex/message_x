defmodule MessageX.MixProject do
  use Mix.Project

  def project do
    [
      app: :message_x,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
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
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.14"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.3 or ~> 0.2.9"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},

      # Added
      {:contex, "~> 0.3"},

      # https://github.com/iandwelker/smserver


      # https://codepen.io/adobewordpress/pen/wGGMaV
      # https://codepen.io/fusco/pen/XbpaYv

      # {:surface, ">= 0.0.0-alpha"},
      {:exzeitable, "~> 0.4.3"},
      # {:live_props, "~> 0.2.1"},
      {:uncharted_phoenix, "~> 0.2.0"},
      # {:phoenix_live_view,
      #  [
      #    env: :prod,
      #    git: "https://github.com/phoenixframework/phoenix_live_view.git",
      #    tag: "597c5ddf8af2ca39216a3fe5a44c066774de3abd",
      #    override: true
      #  ]},
      # {:surface, git: "https://github.com/msaraiva/surface.git", tag: "v0.1.0-rc.1"},
      # {:surface_bulma, github: "msaraiva/surface_bulma"},
      # {:dark_matter, ">= 1.0.3"},
      # {:dark_ecto, ">= 0.0.0", path: "../../dark-elixir/dark_ecto"},
      {:dark_dev, ">= 1.0.0", only: [:dev, :test], runtime: false},
      {:chat_db, path: "../chat_db"},
      {:applescripts_ex, path: "../applescripts_ex"}
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
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end

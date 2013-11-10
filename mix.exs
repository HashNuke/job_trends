defmodule JobTrends.Mixfile do
  use Mix.Project

  def project do
    [ app: :job_trends,
      version: "0.0.1",
      dynamos: [JobTrends.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/job_trends/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { JobTrends, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
      { :riak_pool,  github: "HashNuke/riak_pool"},
      { :jsx,    github: "talentdeficit/jsx", tag: "v1.4.3" }
    ]
  end
end

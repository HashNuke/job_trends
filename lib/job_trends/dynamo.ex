defmodule JobTrends.Dynamo do
  use Dynamo

  config :dynamo,
    # The environment this Dynamo runs on
    env: Mix.env,

    # The OTP application associated with this Dynamo
    otp_app: :job_trends,

    # The endpoint to dispatch requests to
    endpoint: ApplicationRouter,

    # The route from which static assets are served
    # You can turn off static assets by setting it to false
    static_route: "/static"

  # Uncomment the lines below to enable the cookie session store
  # config :dynamo,
  #   session_store: Session.CookieStore,
  #   session_options:
  #     [ key: "_job_trends_session",
  #       secret: "q10iQIoZvR3Ga1J0BPnUZIUN0HpNDKvIhiVyk0kHfbrdWudLDPU9v+wItmFeSp/L"]

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end

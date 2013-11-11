defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end


  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end

  @prepare :authenticate_user
  post "/api/jobs" do
    raw_data = conn.params["job"] |> :jsx.decode
    data = []

    # For locations, send an array of dicts with each having
    # "latitude", "longitude" and country code as "country"
    fields = ["title", "description", "date", "locations", "source"]

    json = parse_job_params(fields, [], raw_data) |> :jsx.encode

    {:ok, obj} = :riakc_obj.new("job_trends_jobs", :undefined, json, "application/json")
      |> RiakPool.put

    conn.resp 200, :jsx.encode([ok: :riakc_obj.key(obj)])
  end


  defp parse_job_params([], data, raw_data) do
    data
  end

  defp parse_job_params(fields, data, raw_data) do
    [field | rest] = fields
    if ListDict.has_key?(raw_data, field) do
      data = ListDict.merge(
        data,
        [ {field, ListDict.get(raw_data, field)} ]
      )
    end
    parse_job_params(rest, data, raw_data)
  end


  defp authenticate_user(conn) do
    {:ok, api_key} = :application.get_env(:job_trends, :api_key)
    unless api_key == conn.params["token"] do
      halt! conn.status(401)
    end
  end
end

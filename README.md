# JobTrends

Job trends application in Elixir using the Dynamo framework

### Installation

Requires Elixir and Riak to be installed. Once done, copy-paste the following in your terminal.

    git clone https://github.com/HashNuke/job_trends.git &
    cd job_trends &
    mix deps.get

To start the server, first start Riak, using `riak start`

Then run `iex -S mix server` to start the server and the console. The application will now be accessible at `http://localhost:4000`

### Setting API key

In the console after starting the server, run the following:

    :application.set_env(:job_trends, :api_key, "some_random_string")

### Data sources

TODO decide later

#### Job sites to parse

* Github Jobs
* Stackoverflow Careers
* HasGeek Job board
* 37signals job board
* Hacker News “Who’s Hiring?” threads

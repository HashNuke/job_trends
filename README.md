# JobTrends

Job trends application in Elixir using the Dynamo framework

## Setup

### Installation

Requires Elixir and Riak to be installed. Once done, copy-paste the following in your terminal.

    git clone https://github.com/HashNuke/job_trends.git &
    cd job_trends &
    mix deps.get

To start the server, first start Riak, using `riak start`

Then run `iex -S mix server` to start the server and the console. The application will now be accessible at `http://localhost:4000`

To quit the server and the console, press ctrl+c, then enter "a" for abort.

### Setting API key

In the console after starting the server, run the following:

    :application.set_env(:job_trends, :api_key, "some_random_string")

## API

To API calls add the param `token` with the API key

### POST `/api/jobs`

Adds a job. Post a param called `job` with the job data encoded in json.

The json can have the following fields:

* `title` - job title
* `description` - job description
* `date` - date the job was posted, as an integer in YYYYMMDD format
* `source` - Code name of the job site (refer below in the "Data Sources" section for code names).
* `url` - full url of the job post
* `locations` - an array of json objects with the keys `latitude`, `longitude` and `country` (country code of the country)

Here's some valid json for the job

    {
      "title": "Chopstick programmer",
      "description": "Must know how to use chopsticks. Bonus: Must know how to walk using chopsticks",
      "data": 20131124,
      "source": "ghj",
      "url": "http://jobs.github.com/jobs/chopstick-programmer",
      locations: [
        {"country": "IN", "latitude": 34.155, "longitude": 75.162},
        {"country": "US", "latitude": 45.152, "longitude": 15.3415}
      ]
    }

On success will return json of the form `{"ok": "3kgdsn328wefb34f"}`. The value of the `ok` key will be the job ID in the database.

## Data sources

TODO for list of tools or languages decide later

### Job sites to parse (and their code names used in the database)

* Github Jobs (`ghj`)
* Stackoverflow Careers (`soc`)
* HasGeek Job board (`hjb`)
* 37signals job board (`37jb`)
* Hacker News “Who’s Hiring?” threads (`hnwh`)

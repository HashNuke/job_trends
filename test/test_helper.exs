Dynamo.under_test(JobTrends.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule JobTrends.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

Dynamo.under_test(StackAnalysis.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule StackAnalysis.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

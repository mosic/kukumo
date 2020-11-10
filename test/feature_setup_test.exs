Code.require_file("test_helper.exs", __DIR__)

defmodule Kukumo.FeatureSetupTest do
  use ExUnit.Case

  describe "Features can import steps from other features" do
    test "ignores wrong setup" do
      defmodule FeatureSetupTest do
        use Kukumo.Feature, file: "simplest.feature"
        @moduletag :another_module_tag

        tag @another_module_tag do
          4
        end

        defthen ~r/^I provide Then$/, _vars, _state do
          assert true
        end
      end

      {result, _output} = KukumoTestHelper.run()
      assert result == %{failures: 0, skipped: 0, total: 1, excluded: 0}
    end

    test "uses correct setup" do
      defmodule FeatureSetupTest1 do
        use Kukumo.Feature, file: "simplest.feature"
        @moduletag :module_tag

        tag @module_tag do
          {:ok, %{module_state: "state"}}
        end

        defthen ~r/^I provide Then$/, _vars, state do
          assert state.module_state == "state"
        end
      end

      {result, _output} = KukumoTestHelper.run()
      assert result == %{failures: 0, skipped: 0, total: 1, excluded: 0}
    end
  end
end

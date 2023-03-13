defmodule SpryCov.FailingTest do
  use SpryCov.Case, async: true

  test "with failing test don't report coverage" do
    in_fixture("failing_test", fn path ->
      {output, exit_code} = mix_code(["test", "--cover"], path)
      assert output =~ "1 failure"

      expected_exit_code =
        if Version.match?(System.version(), ">= 1.13.0") do
          2
        else
          1
        end

      assert exit_code == expected_exit_code

      refute output =~ "The following files are missing coverage:"
      refute output =~ "SpryCov total coverage:"
    end)
  end
end

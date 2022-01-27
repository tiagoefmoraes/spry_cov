defmodule SpryCovTest do
  use SpryCov.Case

  test "with full coverage reports the coverage" do
    in_fixture("full_cover", fn ->
      {output, 0} = mix_code(["test", "--cover"])
      assert output =~ "SpryCov"
      assert output =~ "0 failures"
      assert output =~ " 100.00% | A"
      assert output =~ " 100.00% | Total"
    end)
  end

  test "with no coverage reports the coverage" do
    in_fixture("no_cover", fn ->
      {output, 3} = mix_code(["test", "--cover"])
      assert output =~ "SpryCov"
      assert output =~ "0 failures"
      assert output =~ " 0.00% | A"
      assert output =~ " 0.00% | Total"
    end)
  end

  test "with failing test don't report coverage" do
    in_fixture("failing_test", fn ->
      {output, 2} = mix_code(["test", "--cover"])
      assert output =~ "1 failure"

      refute output =~ "Coverage"
      refute output =~ "SpryCov"
      refute output =~ " 0.00% | A"
      refute output =~ " 0.00% | Total"
    end)
  end
end

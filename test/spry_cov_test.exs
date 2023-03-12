defmodule SpryCov.FullCoverTest do
  use SpryCov.Case, async: true

  test "with full coverage reports the coverage" do
    in_fixture("full_cover", fn ->
      {output, 0} = mix_code(["test", "--cover"])
      assert output =~ "0 failures"
      refute output =~ "The following files are missing coverage:"
      assert output =~ "SpryCov total coverage: 100.00%"
    end)
  end
end

defmodule SpryCov.NoCoverTest do
  use SpryCov.Case, async: true

  test "with no coverage reports the coverage" do
    in_fixture("no_cover", fn ->
      {output, 3} = mix_code(["test", "--cover"])
      assert output =~ "0 failures"

      assert output =~ """
             The following files are missing coverage:
             lib/a.ex                                                         0.00% < 100.00% A
               lib/a.ex:2
             lib/b.ex                                                         0.00% < 100.00% B
               lib/b.ex:2

             SpryCov total coverage:   0.00%
             """
    end)
  end

  test "running one file reports coverage for only that test's code" do
    in_fixture("no_cover", fn ->
      {output, 3} = mix_code(["test", "--cover", "test/b_test_fixture.exs"])
      assert output =~ "1 test, 0 failures"

      assert output =~ """
             The following files are missing coverage:
             lib/b.ex                                                         0.00% < 100.00% B
               lib/b.ex:2

             SpryCov total coverage:   0.00%
             """
    end)
  end
end

defmodule SpryCov.FailingTest do
  use SpryCov.Case, async: true

  test "with failing test don't report coverage" do
    in_fixture("failing_test", fn ->
      {output, exit_code} = mix_code(["test", "--cover"])
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

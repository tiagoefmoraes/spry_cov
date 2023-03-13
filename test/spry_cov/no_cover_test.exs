defmodule SpryCov.NoCoverTest do
  use SpryCov.Case, async: true

  test "with no coverage reports the coverage" do
    in_fixture("no_cover", fn path ->
      {output, 3} = mix_code(["test", "--cover"], path)
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
    in_fixture("no_cover", fn path ->
      {output, 3} = mix_code(["test", "--cover", "test/b_test_fixture.exs"], path)
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

defmodule SpryCov.FullCoverTest do
  use SpryCov.Case, async: true

  test "with full coverage reports the coverage" do
    in_fixture("full_cover", fn path ->
      {output, 0} = mix_code(["test", "--cover"], path)
      assert output =~ "0 failures"
      refute output =~ "The following files are missing coverage:"
      assert output =~ "SpryCov total coverage: 100.00%"
    end)
  end
end

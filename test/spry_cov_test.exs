defmodule SpryCovTest do
  use ExUnit.Case
  doctest SpryCov

  test "greets the world" do
    assert SpryCov.hello() == :world
  end
end

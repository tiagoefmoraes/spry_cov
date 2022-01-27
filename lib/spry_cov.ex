defmodule SpryCov do
  @moduledoc """
  To be used as `:test_coverage` `:tool` in `mix.exs`
  """

  @doc false
  def start(compile_path, opts) do
    Mix.shell().info("SpryCov ...")
    Mix.Tasks.Test.Coverage.start(compile_path, opts)
  end
end

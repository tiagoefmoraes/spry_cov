defmodule SpryCov do
  @moduledoc """
  To be used as `:test_coverage` `:tool` in `mix.exs`
  """

  @doc false
  def start(compile_path, opts) do
    monitor_ex_unit()
    coverage_callback = start_coverage(compile_path, opts)

    fn ->
      %{failures: failures} = ex_unit_status()

      if failures == 0 do
        Mix.shell().info("\nGenerating SpryCov results ...\n")
        generate_cover_results(coverage_callback)
      end
    end
  end

  defp monitor_ex_unit() do
    pid = self()
    ExUnit.after_suite(&send(pid, {:suite_status, &1}))
  end

  defp ex_unit_status() do
    receive do
      {:suite_status, status} -> status
    after
      0 -> raise "no suite status"
    end
  end

  defp start_coverage(compile_path, opts) do
    Mix.Tasks.Test.Coverage.start(compile_path, opts)
  end

  defp generate_cover_results(coverage_callback) do
    coverage_callback.()
  end
end

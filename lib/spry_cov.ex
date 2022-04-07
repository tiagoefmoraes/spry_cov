defmodule SpryCov do
  @moduledoc """
  To be used as `:test_coverage` `:tool` in `mix.exs`

  ## Configuration

  ```elixir
  def project() do
    [
      ...
      test_coverage: [tool: SpryCov]
      ...
    ]
  end
  ```
  """

  alias SpryCov.Files

  @default_threshold 100

  @doc false
  def start(compile_path, opts) do
    monitor_ex_unit()
    coverage_callback = start_coverage(compile_path, opts)

    fn ->
      %{failures: failures} = ex_unit_status()

      if failures == 0 do
        generate_cover_results(opts, coverage_callback)
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
    Mix.Tasks.Test.Coverage.start(compile_path, Keyword.put(opts, :summary, false))
  end

  defp module_path(module) do
    module.module_info(:compile)[:source]
    |> List.to_string()
    |> Path.relative_to_cwd()
  end

  defp generate_cover_results(opts, coverage_callback) do
    coverage_callback.()

    {module_results, totals} = gather_coverage(opts)
    summary_opts = Keyword.get(opts, :summary, true)
    threshold = get_threshold(summary_opts)

    if summary_opts do
      summary(module_results, threshold)
    end

    print_total(totals)

    if totals < threshold do
      System.at_exit(fn _ -> exit({:shutdown, 3}) end)
    end

    :ok
  end

  defp ignored?(mod, ignores) do
    Enum.any?(ignores, &ignored_any?(mod, &1))
  end

  defp ignored_any?(mod, %Regex{} = re), do: Regex.match?(re, inspect(mod))
  defp ignored_any?(mod, other), do: mod == other

  defp summary(module_results, threshold) do
    module_results =
      module_results
      |> Enum.filter(fn {coverage, _, _} -> coverage < threshold end)
      |> filter_selected_modules()
      |> Enum.sort(:desc)

    if Enum.any?(module_results) do
      print_summary(module_results, threshold)
    end

    :ok
  end

  defp filter_selected_modules(modules) do
    mix_test_files = Files.mix_test_files()

    if Enum.empty?(mix_test_files) do
      modules
    else
      supposed_lib_files = Files.supposed_lib_files(mix_test_files)

      Enum.filter(modules, fn {_, name, _} ->
        file = module_path(name)

        Enum.any?(supposed_lib_files, fn modified_file ->
          String.starts_with?(file, modified_file)
        end)
      end)
    end
  end

  defp print_total(totals) do
    Mix.shell().info([:light_black, "SpryCov total coverage: #{format_number(totals, 6)}%"])
  end

  defp gather_coverage(opts) do
    {:result, _ok = results, _fail} = :cover.analyse(:coverage, :line)
    ignore = opts[:ignore_modules] || []
    keep = Enum.reject(:cover.modules(), &ignored?(&1, ignore))

    keep_set = MapSet.new(keep)

    ignored_lines_by_module =
      for module <- keep_set,
          lines = ignored_lines(module),
          lines != [],
          into: %{} do
        {module, lines}
      end

    # When gathering coverage results, we need to skip any
    # entry with line equal to 0 as those are generated code.
    #
    # We may also have multiple entries on the same line.
    # Each line is only considered once.
    #
    # We use ETS for performance, to avoid working with nested maps.
    table = :ets.new(__MODULE__, [:set, :private])

    try do
      for {{module, line}, cov} <- results,
          module in keep_set,
          line != 0,
          ignored_lines = Map.get(ignored_lines_by_module, module, []),
          !Enum.member?(ignored_lines, line) do
        case cov do
          {1, 0} -> :ets.insert(table, {{module, line}, true})
          {0, 1} -> :ets.insert_new(table, {{module, line}, false})
        end
      end

      module_results =
        for module <- keep do
          {read_cover_results(table, module), module, read_not_covered_lines(table, module)}
        end

      {module_results, read_cover_results(table, :_)}
    after
      :ets.delete(table)
    end
  end

  defp read_cover_results(table, module) do
    covered = :ets.select_count(table, [{{{module, :_}, true}, [], [true]}])
    not_covered = :ets.select_count(table, [{{{module, :_}, false}, [], [true]}])
    percentage(covered, not_covered)
  end

  defp read_not_covered_lines(table, module) do
    :ets.select(table, [{{{module, :"$1"}, false}, [], [:"$$"]}])
    |> Enum.flat_map(& &1)
    |> Enum.sort()
  end

  defp percentage(0, 0), do: 100.0
  defp percentage(covered, not_covered), do: covered / (covered + not_covered) * 100

  defp print_summary(results, threshold) do
    Mix.shell().info("The following files are missing coverage:")
    results |> Enum.sort() |> Enum.each(&display(&1, threshold))
    Mix.shell().info("")
  end

  defp display({percentage, name, not_covered_lines}, threshold) do
    file_path = module_path(name)

    Mix.shell().info([
      String.pad_trailing(file_path, 60),
      format_number(percentage, 9),
      "% < #{format_number(threshold, 6)}% ",
      format_name(name)
    ])

    not_covered_lines
    |> Enum.each(fn line ->
      Mix.shell().info([
        color(percentage, threshold),
        "  ",
        file_path,
        ":",
        Integer.to_string(line)
      ])
    end)
  end

  defp color(percentage, true), do: color(percentage, @default_threshold)
  defp color(_, false), do: ""
  defp color(percentage, threshold) when percentage >= threshold, do: :green
  defp color(_, _), do: :red

  defp format_number(number, length) when is_integer(number),
    do: format_number(number / 1, length)

  defp format_number(number, length), do: :io_lib.format("~#{length}.2f", [number])

  defp format_name(mod) when is_atom(mod), do: inspect(mod)

  defp get_threshold(opts) when is_boolean(opts), do: @default_threshold
  defp get_threshold(opts), do: Keyword.get(opts, :threshold, @default_threshold)

  defp ignored_lines(module) do
    {:docs_v1, _, _, _, _, _, docs} = Code.fetch_docs(module)

    for {{:function, :__struct__, _}, line, _, _, %{}} <- docs,
        into: MapSet.new() do
      line
    end
  end
end

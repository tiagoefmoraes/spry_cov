defmodule Mix.Tasks.SpryCov.Check do
  use Mix.Task

  @shortdoc "Checks that each `test` file path has a respective `lib` file path"

  @moduledoc """
  Checks that each `test` file path has a respective `lib` file path

      $ mix spry_cov.check

  See `SpryCov.Files.supposed_lib_file/2` for information on the rules used.
  """

  @impl true
  def run(args) do
    case args do
      [] -> general()
      _ -> Mix.raise("Invalid arguments, expected: mix spry_cov.check")
    end
  end

  defp general() do
    project = Mix.Project.config()
    test_paths = project[:test_paths] || default_test_paths()
    test_pattern = project[:test_pattern] || "*_test.exs"
    test_files = Mix.Utils.extract_files(test_paths, test_pattern)
    lib_files = Mix.Utils.extract_files(["lib"], "*.ex")

    Mix.shell().info("SpryCov checking #{test_files |> length()} test file(s)")

    without_match =
      test_files
      |> Enum.count(fn test_file ->
        lib_file = SpryCov.Files.supposed_lib_file(test_paths, test_file) <> ".ex"

        if Enum.member?(lib_files, "#{lib_file}") do
          false
        else
          Mix.shell().info([
            :red,
            "  #{test_file} was expected to test #{lib_file} that don't exist"
          ])

          true
        end
      end)

    Mix.shell().info(
      "SpryCov check found #{without_match} test file(s) without a respective lib file"
    )
  end

  defp default_test_paths do
    if File.dir?("test") do
      ["test"]
    else
      []
    end
  end
end

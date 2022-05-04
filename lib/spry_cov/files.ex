defmodule SpryCov.Files do
  @doc """
  Returns the list of files and/or directories given to `mix test`

  ## Examples

      iex> mix_test_files()

      iex> mix_test_files(["test"])
      []

      iex> mix_test_files(["test", "--cover"])
      []

      iex> mix_test_files(["test", "test/spry_cov/utils_test.exs"])
      ["test/spry_cov/utils_test.exs"]

      iex> mix_test_files(["test", "--cover", "test/spry_cov/utils_test.exs"])
      ["test/spry_cov/utils_test.exs"]

      iex> mix_test_files(["test", "test/spry_cov/"])
      ["test/spry_cov/"]

      iex> mix_test_files(["test", "test/spry_cov/a_test.exs", "test/spry_cov/b_test_fixture.exs"])
      ["test/spry_cov/a_test.exs", "test/spry_cov/b_test_fixture.exs"]
  """
  def mix_test_files(args \\ System.argv()) do
    args
    |> Enum.filter(&String.starts_with?(&1, "test/"))
  end

  @doc """
  Returns the supposed production file names for the test files and/or directories

  ## Examples

      iex> supposed_lib_files(["test"], [])
      []

      iex> supposed_lib_files(["test"], ["test/spry_cov/utils_test.exs"])
      ["lib/spry_cov/utils"]
  """
  def supposed_lib_files(test_paths, mix_test_files) do
    mix_test_files
    |> Enum.map(&supposed_lib_file(test_paths, &1))
  end

  @doc """
  Returns the supposed production file name for the test file and/or directory

  Parameter `test_paths` is the `:test_paths` of your `mix.exs` configuration,
  `test_file` is the test file to determine the supposed lib file.

  Replaces `test_paths` in the start of `test_file` with `"lib/"`

  ## Examples

      iex> SpryCov.Files.supposed_lib_file(["test"], "test/spry_cov/utils_test.exs")
      "lib/spry_cov/utils"

      iex> SpryCov.Files.supposed_lib_file(["test"], "test/spry_cov/")
      "lib/spry_cov/"

      iex> SpryCov.Files.supposed_lib_file(["test"], "test/spry_cov/utils2_test.exs")
      "lib/spry_cov/utils2"

      iex> SpryCov.Files.supposed_lib_file(["test"], "test/spry_cov/utils_test.exs")
      "lib/spry_cov/utils"

      iex> SpryCov.Files.supposed_lib_file(["test"], "test/spry_cov/")
      "lib/spry_cov/"

      iex> SpryCov.Files.supposed_lib_file(["test/unit"], "test/unit/spry_cov/")
      "lib/spry_cov/"
  """
  def supposed_lib_file(test_paths, test_file) do
    test_paths
    |> Enum.reduce(test_file, &String.replace_leading(&2, "#{&1}/", "lib/"))
    |> String.replace(~r"_test(_\w+)?.exs$", "")
  end
end

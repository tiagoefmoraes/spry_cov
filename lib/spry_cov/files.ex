defmodule SpryCov.Files do
  @moduledoc false

  @doc """
  Returns the list of files and/or directories given to `mix test`

  ## Examples

    iex> SpryCov.Files.mix_test_files()

    iex> SpryCov.Files.mix_test_files(["test"])
    []

    iex> SpryCov.Files.mix_test_files(["test", "--cover"])
    []

    iex> SpryCov.Files.mix_test_files(["test", "test/spry_cov/utils_test.exs"])
    ["test/spry_cov/utils_test.exs"]

    iex> SpryCov.Files.mix_test_files(["test", "--cover", "test/spry_cov/utils_test.exs"])
    ["test/spry_cov/utils_test.exs"]

    iex> SpryCov.Files.mix_test_files(["test", "test/spry_cov/"])
    ["test/spry_cov/"]

    iex> SpryCov.Files.mix_test_files(["test", "test/spry_cov/a_test.exs", "test/spry_cov/b_test_fixture.exs"])
    ["test/spry_cov/a_test.exs", "test/spry_cov/b_test_fixture.exs"]
  """
  def mix_test_files(args \\ System.argv()) do
    args
    |> Enum.filter(&String.starts_with?(&1, "test/"))
  end

  @doc """
    Returns the supposed production file names for the test files and/or directories

    ## Examples

      iex> SpryCov.Files.supposed_lib_files([])
      []

      iex> SpryCov.Files.supposed_lib_files(["test/spry_cov/utils_test.exs"])
      ["lib/spry_cov/utils"]
  """
  def supposed_lib_files(mix_test_files) do
    mix_test_files
    |> Enum.map(&supposed_lib_file/1)
  end

  @doc """
  Returns the supposed production file name for the test file and/or directory

  ## Examples

    iex> SpryCov.Files.supposed_lib_file("test/spry_cov/utils_test.exs")
    "lib/spry_cov/utils"

    iex> SpryCov.Files.supposed_lib_file("test/spry_cov/")
    "lib/spry_cov/"

    iex> SpryCov.Files.supposed_lib_file("test/spry_cov/utils2_test.exs")
    "lib/spry_cov/utils2"

    iex> SpryCov.Files.supposed_lib_file("test/spry_cov/utils_test.exs")
    "lib/spry_cov/utils"

    iex> SpryCov.Files.supposed_lib_file("test/spry_cov/")
    "lib/spry_cov/"
  """
  def supposed_lib_file(test_file) do
    test_file
    |> String.replace_leading("test/", "lib/")
    |> String.replace(~r"_test(_\w+)?.exs$", "")
  end
end

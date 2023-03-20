ExUnit.start()

defmodule SpryCov.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import SpryCov.Case
    end
  end

  # inspired on https://github.com/elixir-lang/elixir/blob/10f62dd0552dc19705faf2e2c6aa9084603bdae0/lib/mix/test/test_helper.exs#L104

  def fixture_path do
    Path.expand("fixtures", __DIR__)
  end

  def fixture_path(extension) do
    Path.join(fixture_path(), extension)
  end

  def tmp_path do
    Path.expand("../tmp", __DIR__)
  end

  def tmp_path(extension) do
    Path.join(tmp_path(), extension)
  end

  defmacro in_fixture(which, block) do
    module = inspect(__CALLER__.module)
    function = Atom.to_string(elem(__CALLER__.function, 0))
    tmp = Path.join(module, function)

    quote do
      unquote(__MODULE__).in_fixture(unquote(which), unquote(tmp), unquote(block))
    end
  end

  def in_fixture(which, tmp, function) do
    src = fixture_path(which)
    dest = tmp_path(String.replace(tmp, ":", "_"))

    File.rm_rf!(dest)
    File.mkdir_p!(dest)
    File.cp_r!(src, dest)

    function.(dest)
  end

  def mix_code(args, path) when is_list(args) do
    System.cmd("mix", args, stderr_to_stdout: true, cd: path)
  end
end

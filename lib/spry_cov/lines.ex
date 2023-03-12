defmodule SpryCov.Lines do
  @doc """
  Returns the list of files and/or directories given to `mix test`

  ## Examples

      iex> drop_sequential([1, 2, 3])
      [1]

      iex> drop_sequential([1, 3, 5])
      [1, 3, 5]

      iex> drop_sequential([1, 2, 4])
      [1, 4]

  """
  def drop_sequential(lines) when is_list(lines) do
    drop_sequential(lines, {-1, []}) |> :lists.reverse()
  end

  defp drop_sequential([line | tail], {prior, acc}) do
    acc =
      cond do
        line == prior + 1 -> acc
        true -> [line | acc]
      end

    drop_sequential(tail, {line, acc})
  end

  defp drop_sequential([], {_, acc}), do: acc
end

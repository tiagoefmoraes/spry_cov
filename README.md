# SpryCov

Actionable coverage report with your test results.

```sh
1 test, 0 failures

The following files are missing coverage:
lib/a.ex                                                         0.00% < 100.00% A
  lib/a.ex:2

SpryCov total coverage:   0.00%
```

## Features

- Only generate coverage report if all the tests pass
- Only display files with less coverage then the configured threshold
- See just the files and lines that are missing coverage

## Installation

Add `spry_cov` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spry_cov, "~> 0.1.0"}
  ]
end
```

Configure the project in `mix.exs`:

```elixir
def project() do
  [
    ...
    test_coverage: [tool: SpryCov]
    ...
  ]
end
```

Some of the default [mix test options](https://hexdocs.pm/mix/Mix.Tasks.Test.html#module-coverage) are compatible with `SpryCov`

## Usage

Run `mix test --cover`

## TODO

- Publish in [Hex](https://hex.pm/docs/publish)
- Configure [ExDoc](https://github.com/elixir-lang/ex_doc#using-exdoc-with-mix) and publish on [HexDocs](https://hexdocs.pm)
- Display filtered results when running the test for a specific file or folder
  - `mix test --cover test/lib/a_test.exs` display only coverage for `lib/a.ex`
  - `mix test --cover test/lib/sub/` display only coverage for files in `lib/sub/`

## License

Copyright (c) 2022, Tiago Moraes.

SpryCov source code is released under Apache 2 License.

Check [NOTICE](NOTICE) and [LICENSE](LICENSE) files for more information.

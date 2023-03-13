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
- Display filtered results when running the test for a specific file or folder
  - `mix test --cover test/lib/a_test.exs` display only coverage for `lib/a.ex`
  - `mix test --cover test/lib/sub/` display only coverage for files in `lib/sub/`
- Don't report `defstruct` as not covered

## Installation

Add `spry_cov` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spry_cov, "~> 0.3.1", only: [:test]},
  ]
end
```

Configure the project in `mix.exs`:

```elixir
def project() do
  [
    ...
    test_coverage: [tool: SpryCov],
    ...
  ]
end
```

Some of the default [mix test options](https://hexdocs.pm/mix/Mix.Tasks.Test.html#module-coverage) are compatible with `SpryCov`

## Usage

Run `mix test --cover`

SpryCov will output all files with that don't meet the threshold with the lines not covered.
It will get very "noisy" in projects with many coverage gaps, we can workaround by using `grep`

```bash
mix test --cover | grep lib/a.ex
```

When running tests for only a few files and/or directories SpryCov will display the coverage for only those files and/or directories, there is no need for using `grep`.

```bash
mix test --cover test/a_test.exs
```

> Be careful because only the code being tested by those tests is going to be reported

## License

Copyright (c) 2022, Tiago Moraes.

SpryCov source code is released under Apache 2 License.

Check [NOTICE](NOTICE) and [LICENSE](LICENSE) files for more information.

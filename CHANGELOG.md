# Changelog

## dev ()

* Handle multiple `:test_paths` in `mix.exs`

## v0.3.0 (2022-04-07)

* Don't report `defstruct` as not covered

## v0.2.0 (2022-04-05)

* Support for Elixir 1.12

## v0.1.0 (2022-02-01)

* Only generate coverage report if all the tests pass
* Only display files with less coverage then the configured `threshold`
* See just the files and lines that are missing coverage
* Display filtered results when running the test for a specific file or folder
  * `mix test --cover test/lib/a_test.exs` display only coverage for `lib/a.ex`
  * `mix test --cover test/lib/sub/` display only coverage for files in `lib/sub/`

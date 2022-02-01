# Release Instructions

  1. Bump version in related files below(mix.exs)
  1. Run tests:
      1. `mix test` in the root folder
  1. Commit and push code
      1. `git commit -m "Version $(mix version)"`
      1. `git push`
  1. Publish packages and docs after pruning any extraneous uncommitted files
      1. `mix hex.publish`
  1. Test the published version in other project
      1. `mix deps.get && mix compile && mix test --cover`
  1. Create tag and push
      1. `git tag -a "v$(mix version)" -m "Version $(mix version)"`
      1. `git push origin "v$(mix version)"`
  1. Start -dev version in related files below

## Files with version

* [mix.exs](mix.exs)
* [CHANGELOG.md](CHANGELOG.md)
* [README.md](README.md)

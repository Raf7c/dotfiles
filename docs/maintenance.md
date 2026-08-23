# Maintenance

What keeps this repo honest, and what to do when a machine stops
behaving. Nothing here changes a machine; for that, see
[installer.md](installer.md).

## Convention

Documentation is fixed in the same commit as the code it describes. Every
audit of this repo found the same failure mode, a correction landing in
one place and not in its satellite, so the rule is the cheapest defence
there is.

## CI

`.github/workflows/ci.yml` runs the repo's own bar on a neutral runner,
on every push to `main`/`dev` and on every pull request:

- **syntax**: `dash -n` over the POSIX scripts, `bash -n`, and `zsh -n`
  over every zsh file, found by `find` (see the caution below).
- **shellcheck**, warning level and above.
- **shfmt** against `.editorconfig`, where `-d` must stay silent. Every file it
  checks is **listed explicitly**; shellcheck names two of its own (`.bashrc`,
  `.bash_profile`), which its `find` cannot reach.
- **yamllint** on `.github` **and on `.yamllint.yml` itself**, that file
  stating which of its defaults bend and why (a SHA-pinned `uses:` line
  cannot fit 80 columns).

> [!CAUTION]
> Handed a **directory**, shfmt silently skips dotfiles and has no flag to
> include them. Every zsh file has to be named on the command line, or it
> goes unchecked without a word: that is how `.zshrc` escaped the formatter
> for a week. `find` does list them, which is why the syntax step can get
> away with `-name '.z*'`.

shellcheck, shfmt and yamllint are installed by `mise-action` reading this
repo's own `.config/mise/config.toml`, so local and CI lint with the same
versions, which is the entire point of pinning them
([tools.md](tools.md)).

Actions are pinned to full commit SHAs (a tag can be repointed at a
malicious commit, a SHA cannot) and `permissions: contents: read` keeps
the token to what a linter needs. Dependabot proposes the bumps weekly.

## When something breaks

No health-check script: the checks that matter are one command each.

| Symptom | First move |
|---|---|
| a zsh file was edited, the shell errors | `zsh -n ~/.zshenv ~/.config/zsh/.zshrc` |
| a config seems ignored, a link looks wrong | `. setup/manifest.sh && dotfiles_links`, the source of truth; compare with `ls -l ~` |
| an install did something unexpected | replay it: `./run install -n` prints every command and writes nothing |
| plugins missing after an update | `./run upgrade`, then `exec zsh` |
| tmux ignores the config | `tmux kill-server`, since options are read once, at server start |
| vim indents with spaces | `vim --version`, then `:verbose set expandtab?`: the line names the file that won |
| history is not saved | the directory must exist and be writable: `ls -ld ~/.local/state/zsh ~/.local/state/bash` |
| a signature will not verify | [git](../.config/git/README.md): checking, and the key's validity window |
| a stray file appears in `$HOME` | some tool ignores XDG: check `env.sh` for a redirect, else delete it ([tools.md](tools.md)) |

Every run's backups: `~/.local/state/dotfiles/backups/<timestamp>/`.

---

See also: [installer.md](installer.md) for what changes a machine, and
[tools.md](tools.md) for why shellcheck and shfmt are authorities.

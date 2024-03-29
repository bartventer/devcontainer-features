## OS Support

This Feature should work on recent versions of Arch Linux.

## Customizing the command prompt

By default, this script provides a custom command prompt that includes information about the git repository for the current folder. However, with certain large repositories, this can result in a slow command prompt due to the performance of needed git operations.

For performance reasons, a "dirty" indicator that tells you whether or not there are uncommitted changes is disabled by default. You can opt to turn this on for smaller repositories by entering the following in a terminal or adding it to your `postCreateCommand`:

```bash
git config devcontainers-theme.show-dirty 1
```

To completely disable the git portion of the prompt for the current folder's repository, you can use this configuration setting instead:

```bash
git config devcontainers-theme.hide-status 1
```

For `zsh`, the default theme is a [standard Oh My Zsh! theme](https://ohmyz.sh/). You may pick a different one by modifying the `ZSH_THEME` variable in `~/.zshrc`.

## Acknowledgments

This project makes use of code from the [devcontainers/features](https://github.com/devcontainers/features/tree/main/src/common-utils) project. We thank the authors of devcontainers/features for their work and for making their code available for reuse.

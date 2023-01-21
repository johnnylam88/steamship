# Steamship Prompt

A customizable prompt for Bourne-compatible shells.
This project is inspired by [Spaceship][] for `zsh` but is for older breeds
of Bourne shells, e.g., `ksh`, `bash`, `dash`, and POSIX `sh`, hence
*"Steamship"*.

## Features

*Steamship* is a prompt that shows useful information relevant to the current
directory and login session.

  - Host and user display if needed
  - `git` repository status
  - Container status
  - `tmux` session

## Installation

Installing *Steamship* is as easy as cloning the repository and then sourcing
*Steamship* in your shell configuration file.

  1. Clone this repository somewhere, for example to `$HOME/.local/share/steamship`.

    $ mkdir -p "$HOME/.local/share"
    $ git clone --depth=1 https://github.com/johnnylam88/steamship.git "$HOME/.local/share/steamship"

  2. Source *Steamship* in your shell configuration file.

    # Insert this snippet into ~/.bashrc or ~/.kshrc.
    #
    # Older shells may need to set the Steamship root.
    #STEAMSHIP_ROOT="$HOME/.local/share/steamship"
    source "$HOME/.local/share/steamship/steamship.sh

## Configuration

*Steamship* can be used after installation with zero configuration, but you
can customize the shell prompt to fit your personal workflow.

### Create configuration file

*Steamship* will automatically source the first configuration file found, if
it exists:

  * `${SPACESHIP_CONFIG}`
  * `$HOME/.steamshiprc`
  * `$HOME/.config/steamship.sh`
  * `$HOME/.config/steamship/steamship.sh`

The file **must** be a valid shell script.

### Customize the prompt

Here is an example configuration file:

    # Start with the ASCII theme to avoid using Unicode (default is 'starship')
    steamship theme ascii

    # show timestamp (default is 'false')
    STEAMSHIP_TIMESTAMP_SHOW=true

    # always show the username (default is 'needed')
    STEAMSHIP_USER_SHOW=always

## Contribute

Code contributions and bug reports are welcome on the [GitHub][] project page.

[GitHub]: https://github.com/johnnylam88/steamship
[Spaceship]: https://github.com/spaceship-prompt/spaceship-prompt

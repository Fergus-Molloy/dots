#!/bin/sh
# Actual launcher. This does the hard work of figuring out the best way
# to launch the language server or the debug adapter.

# Running this script is a one-time action per project launch, so we opt for
# code simplicity instead of performance. Hence some potentially redundant
# moves here.


did_relaunch=$1

# Get the user's preferred shell
preferred_shell=$(basename "$SHELL")

# Get current dirname
dirname=$(dirname "$0")

case "${did_relaunch}" in
  "")
    if [ "$preferred_shell" = "bash" ]; then
      >&2 echo "Preferred shell is bash, relaunching"
      exec "$(which bash)" "$0" relaunch
    elif [ "$preferred_shell" = "zsh" ]; then
      >&2 echo "Preferred shell is zsh, relaunching"
      exec "$(which zsh)" "$0" relaunch
    elif [ "$preferred_shell" = "fish" ]; then
      >&2 echo "Preferred shell is fish, launching launch.fish"
      exec "$(which fish)" "$dirname/launch.fish"
    else
      >&2 echo "Preferred shell $preferred_shell is not supported, continuing in POSIX shell"
    fi
    ;;
  *)
    # We have an arg2, so we got relaunched
    ;;
esac

# First order of business, see whether we can setup asdf
echo "Looking for asdf install" >&2
ASDF_DIR=${ASDF_DIR:-"${HOME}/.asdf"}

# Check if we have the asdf binary for version >= 0.16.0
if command -v asdf >/dev/null 2>&1; then
    >&2 echo "asdf executable found at $(command -v asdf). Setting ASDF_DIR=${ASDF_DIR} and adding ${ASDF_DATA_DIR}/shims to PATH."
    # If the binary is found, set up environment for newer asdf versions
    export ASDF_DATA_DIR="$ASDF_DIR"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
else
    # Fallback to old method for version <= 0.15.x
    ASDF_SH="${ASDF_DIR}/asdf.sh"       # Path to the old shell script for version <= 0.15.x
    if test -f "$ASDF_SH"; then
        >&2 echo "Legacy pre v0.16.0 asdf install found at $ASDF_SH, sourcing"
        # Source the old asdf.sh script for versions <= 0.15.0
        . "$ASDF_SH"
    else
        >&2 echo "asdf not found"
        >&2 echo "Looking for mise executable"

        # Look for mise executable
        if command -v mise >/dev/null 2>&1; then
            >&2 echo "mise executable found at $(command -v mise), activating"
            eval "$($(command -v mise) env -s "$preferred_shell")"
        else
            >&2 echo "mise not found"
            >&2 echo "Looking for rtx executable"

            # Look for rtx executable
            if command -v rtx >/dev/null 2>&1; then
                >&2 echo "rtx executable found at $(command -v rtx), activating"
                eval "$($(command -v rtx) env -s "$preferred_shell")"
            else
                >&2 echo "rtx not found"
                >&2 echo "Looking for vfox executable"

                # Look for vfox executable
                if command -v vfox >/dev/null 2>&1; then
                    >&2 echo "vfox executable found at $(command -v vfox), activating"
                    eval "$($(command -v vfox) activate "$preferred_shell")"
                else
                    >&2 echo "vfox not found"
                fi
            fi
        fi
    fi
fi

# In case that people want to tweak the path, which Elixir to use, or
# whatever prior to launching the language server or the debug adapter, we
# give them the chance here. ELS_MODE will be set for
# the really complex stuff. Use an XDG compliant path.

els_setup="${XDG_CONFIG_HOME:-$HOME/.config}/elixir_ls/setup.sh"
if test -f "${els_setup}"
then
  >&2 echo "Running setup script $els_setup"
  # shellcheck disable=SC1090
  .  "${els_setup}"
fi

# Setup done. Make sure that we have the proper actual path to this
# script so we can correctly configure the Erlang library path to
# include the local .ez files, and then do what we were asked to do.

readlink_f () {
  cd "$(dirname "$1")" > /dev/null || exit 1
  filename="$(basename "$1")"
  if [ -h "$filename" ]; then
    readlink_f "$(readlink "$filename")"
  else
    echo "$(pwd -P)/$filename"
  fi
}

if [ -z "${ELS_INSTALL_PREFIX}" ]; then
  SCRIPT=$(readlink_f "$0")
  SCRIPTPATH=$(dirname "$SCRIPT")
else
  SCRIPTPATH=${ELS_INSTALL_PREFIX}
fi

export MIX_ENV=prod
# Mix.install prints to stdout and reads from stdin
# we need to make sure it doesn't interfere with LSP/DAP
echo "" | elixir "$SCRIPTPATH/quiet_install.exs" >/dev/null || exit 1

default_erl_opts="-kernel standard_io_encoding latin1 +sbwt none +sbwtdcpu none +sbwtdio none"

if [ "$preferred_shell" = "bash" ]; then
  source "$dirname/exec.bash"
elif [ "$preferred_shell" = "zsh" ]; then
  source "$dirname/exec.zsh"
else
  if [ -z "$ELS_ELIXIR_OPTS" ]
  then
    # in posix shell does not support arrays
    >&2 echo "ELS_ELIXIR_OPTS is not supported in current shell"
  fi
  exec elixir --erl "$default_erl_opts $ELS_ERL_OPTS" "$SCRIPTPATH/launch.exs"
fi

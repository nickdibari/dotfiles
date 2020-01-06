#! /bin/sh

# Alias for activating a virtual environment when moving into a directory
# - Deactivates virtual environment after leaving directory

function cd {
    builtin cd "$@"

    venv_source=$(find . -maxdepth 3 -name activate 2>/dev/null)

    if [[ ! -z $venv_source ]]; then
        source $venv_source

    elif [[ ! -z $VIRTUAL_ENV ]]; then
        deactivate
    fi
}

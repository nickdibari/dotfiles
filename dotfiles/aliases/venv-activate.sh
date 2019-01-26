#! /bin/sh

# Alias for activating a virtual environemt when `cd` into directory
# - This command assumes the virtual environment lives in the venv/ directory
# - You can configure this to your usual virtual environment practices
# - Set $venv_name to whatever name you normally use for setting up virtual environment
# - Deactivates virtual environment after leaving directory

venv_name="venv"

function cd {
    builtin cd "$@"
    if [[ -d $venv_name ]]; then
        source $venv_name/bin/activate

    elif [[ ! -z $VIRTUAL_ENV ]] ; then
        deactivate
    fi
}

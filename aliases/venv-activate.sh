# Alias for activating a virtual environemt when `cd` into directory
# - This command assumes the virtual environment lives in the venv/ directory
# - You can configure this to your usual virtual environment practices
function cd {
    builtin cd "$@"
    if [ -d "venv" ]; then
        source venv/bin/activate
    fi
}

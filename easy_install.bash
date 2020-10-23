#!/bin/bash
set -euo pipefail

# easy_install.bash
# Fetches the dotfiles from remote source and installs them into the users home directory

help() {
    echo <<HELP "usage: ./easy_install.bash [--install-vim] [--install-tmux]
Downloads and installs dotfile configs to \$HOME/.bashrc

--install-vim   Install vim plugins and config files
--install-tmux  Install tmux plugins and config files
    -> Needs tmux to be installed on host
"
HELP
}

fetch_dotfile() {
    url="$1"
    filename="$2"

    echo "Making request to fetch $url"
    curl "$url" -s -o "$filename"
}

install_vim=0
install_tmux=0

while test $# -gt 0
do
    case "$1" in
        --install-vim ) install_vim=1
                        ;;
        --install-tmux ) install_tmux=1
                        ;;
        -h | --help ) help
                      exit 0
                        ;;
    esac
    shift
done

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_ACTIVATION="$DOTFILES_DIR/.activate"
BASH_FILE="$HOME/.bashrc"

if [[ -d "$DOTFILES_DIR" ]]; then
    echo "Clearing old install.."
    rm -rf "$DOTFILES_DIR"
fi

mkdir "$DOTFILES_DIR"
touch "$DOTFILES_ACTIVATION"

# List of dotfiles to fetch and install on the host
# Should be in the form of "$url,$filename" where $filename is the name of the file that will be written
# to the $DOTFILES_DIR directory
DOTFILES=("https://raw.githubusercontent.com/nickdibari/dotfiles/master/dotfiles/aliases/common.sh,common.sh"
"https://raw.githubusercontent.com/nickdibari/dotfiles/master/dotfiles/git_prompts/git-completion.bash,git-completion.bash"
"https://raw.githubusercontent.com/nickdibari/dotfiles/master/dotfiles/git_prompts/git-prompt.sh,git-prompt.sh"
"https://raw.githubusercontent.com/nickdibari/dotfiles/master/dotfiles/system/prompt.sh,prompt.sh"
"https://raw.githubusercontent.com/nickdibari/dotfiles/master/dotfiles/system/venv-activate.sh,venv-activate.sh")

for dotfile in "${DOTFILES[@]}"
do
    url=$(cut -d',' -f1 <<< "$dotfile")
    filename=$(cut -d',' -f2 <<< "$dotfile")
    full_filename="$DOTFILES_DIR/$filename"

    fetch_dotfile "$url" "$full_filename"

    echo "Appending $full_filename to $DOTFILES_ACTIVATION"
    echo ". $full_filename" >> "$DOTFILES_ACTIVATION"
done

echo "Copying your $BASH_FILE file to /tmp in case of revert"
cp "${BASH_FILE}" /tmp/bashrc.bak

if ! grep -qse "### BEGIN dotfiles MANAGED SECTION" "$BASH_FILE"; then
    echo "Adding source of $DOTFILES_ACTIVATION to $BASH_FILE"
    {
        echo ""
        echo "### BEGIN dotfiles MANAGED SECTION"
        echo ". $DOTFILES_ACTIVATION"
        echo '### END dotfiles MANAGED SECTION'
    } >> "$BASH_FILE"
else
    echo "Already have source of $DOTFILES_ACTIVATION in $BASH_FILE"
fi

### Vim Config
if [ "$install_vim" = "1" ]; then
    VIM_DIR="$HOME/.vim_runtime"
    VIM_CONFIG_URL="https://raw.githubusercontent.com/nickdibari/dotfiles/master/configs/vim_config.vim"
    VIM_CONFIG_FILENAME="$VIM_DIR/my_configs.vim"

    if [ ! -d "$VIM_DIR" ]; then
        # Install vim config
        echo "Installing awesome vim config"
        git clone --depth=1 https://github.com/amix/vimrc.git "$VIM_DIR"
        sh "$VIM_DIR/install_awesome_vimrc.sh"
    else
        echo "Awesome vim config already installed"
    fi

    # Add custom vim config
    echo "Installing custom vim config"
    fetch_dotfile "$VIM_CONFIG_URL" "$VIM_CONFIG_FILENAME"
fi


### tmux Config
if [ "$install_tmux" = "1" ]; then
    TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"
    TMUX_CONFIG_URL="https://raw.githubusercontent.com/nickdibari/dotfiles/master/configs/tmux.conf"
    TMUX_CONFIG_FILENAME="$HOME/.tmux.conf"

    if [ ! -d "$TMUX_PLUGIN_DIR" ]; then
        # Install tmux plugin manager
        echo "Installing tmux plugin manager"
        git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"
    else
        echo "tmux plugin manager already installed"
    fi

    # Add tmux config file
    echo "Installing tmux config file"
    fetch_dotfile "$TMUX_CONFIG_URL" "$TMUX_CONFIG_FILENAME"

    # Install tmux plugins
    echo "Installing tmux plugins"
    bash "$TMUX_PLUGIN_DIR/bin/install_plugins"
fi

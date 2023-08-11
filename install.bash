#!/bin/bash
set -euo pipefail

# install.bash
# Installs the dotfiles into the users home directory and adds the activation script to
# the config file sourced by bash on the installation platform

help () {
    cat << HELP
usage: ./install.bash [--install-vim] [--install-tmux]
Installs dotfile configs to the config file sourced by bash on the installation platform

--install-vim   Install vim plugins and config files
--install-tmux  Install tmux plugins and config files
    -> Needs tmux to be installed on host
HELP
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

DOTFILES_SRC="$(dirname "$(readlink -f "$0")")"
DOTFILES_CONFIG="$HOME/.dotfiles_config"
DOTFILES_ACTIVATION="$HOME/.activate"

case "$OSTYPE" in
    linux-*)
    BASH_FILE="$HOME/.bashrc"
    ;;

    darwin*)
    BASH_FILE="$HOME/.profile"
    ;;
esac

touch "$DOTFILES_ACTIVATION"

dotfiles_dirs=$( ls "$DOTFILES_SRC/dotfiles")

for dir in $dotfiles_dirs; do
    dotfiles=$(ls "$DOTFILES_SRC/dotfiles/$dir")

    for file in $dotfiles; do
        filename="$DOTFILES_SRC/dotfiles/$dir/$file"

        echo "Appending $filename to $DOTFILES_ACTIVATION"
        echo ". $filename" >> "$DOTFILES_ACTIVATION"
    done
done

if [[ -f "$BASH_FILE" ]]; then
    echo "Copying your $BASH_FILE file to /tmp in case of revert"
    cp "${BASH_FILE}" /tmp/bashrc.bak
fi

if ! grep -qse "### BEGIN dotfiles MANAGED SECTION" "$BASH_FILE"; then
    echo "Adding source of $DOTFILES_ACTIVATION to $BASH_FILE"
    {
        echo ""
        echo "### BEGIN dotfiles MANAGED SECTION"
        echo "[ -f $DOTFILES_CONFIG ] && . $DOTFILES_CONFIG"
        echo ". $DOTFILES_ACTIVATION"
        echo '### END dotfiles MANAGED SECTION'
    } >> "$BASH_FILE"
else
    echo "Already have source of $DOTFILES_ACTIVATION in $BASH_FILE"
fi

### Vim Config
if [ "$install_vim" = "1" ]; then
    VIM_DIR="$HOME/.vim_runtime"

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
    ln -sf "$DOTFILES_SRC/configs/vim_config.vim" "$VIM_DIR/my_configs.vim"
fi


### tmux Config
if [ "$install_tmux" = "1" ]; then
    TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"

    if [ ! -d "$TMUX_PLUGIN_DIR" ]; then
        # Install tmux plugin manager
        echo "Installing tmux plugin manager"
        git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"
    else
        echo "tmux plugin manager already installed"
    fi

    # Add tmux config file
    echo "Installing tmux config file"
    ln -sf "$DOTFILES_SRC/configs/tmux.conf" ~/.tmux.conf

    # Install tmux plugins
    echo "Installing tmux plugins"
    bash "$TMUX_PLUGIN_DIR/bin/install_plugins"
fi

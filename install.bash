#!/bin/bash
set -euo pipefail

# install.bash
# Installs the dotfiles into the users home directory and adds the activation script to
# the .bashrc file

help () {
    echo "usage: ./install.bash [--install-vim] [--install-tmux]"
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
                      exit 1
                        ;;
    esac
    shift
done

MAIN_DIRECTORY="$HOME/.dotfiles"
MAIN_FILENAME="$MAIN_DIRECTORY/.activate"
BASH_FILE="$HOME/.bashrc"

if [[ -d "$MAIN_DIRECTORY" ]]; then
    echo "Clearing old install.."
    rm -rf "$MAIN_DIRECTORY"
fi

mkdir "$MAIN_DIRECTORY"
touch "$MAIN_FILENAME"

dotfiles_dirs=$( ls "dotfiles")

for dir in $dotfiles_dirs; do
    dotfiles=$(ls dotfiles/"$dir")

    for file in $dotfiles; do
        filename="dotfiles/$dir/$file"

        cp "$filename" "$MAIN_DIRECTORY"
        new_filename="$MAIN_DIRECTORY/$file"

        echo "Appending $new_filename to $MAIN_FILENAME"
        echo ". $new_filename" >> "$MAIN_FILENAME"
    done
done

echo "Copying your $BASH_FILE file to /tmp in case of revert"
cp "${BASH_FILE}" /tmp/bashrc.bak

if ! grep -qse "### BEGIN dotfiles MANAGED SECTION" "$BASH_FILE"; then
    echo "Adding source of $MAIN_FILENAME to $BASH_FILE"
    {
        echo ""
        echo "### BEGIN dotfiles MANAGED SECTION"
        echo ". $MAIN_FILENAME"
        echo '### END dotfiles MANAGED SECTION'
    } >> "$BASH_FILE"
else
    echo "Already have source of $MAIN_FILENAME in $BASH_FILE"
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
    cp configs/vim_config.vim "$VIM_DIR/my_configs.vim"
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
    cp configs/tmux.conf ~/.tmux.conf

    # Install tmux plugins
    echo "Installing tmux plugins"
    bash "$TMUX_PLUGIN_DIR/bin/install_plugins"
fi

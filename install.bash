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

echo "Appending $MAIN_FILENAME to user $BASH_FILE"
echo "" >> "$BASH_FILE"
echo "### BEGIN dotfiles MANAGED SECTION" >> "$BASH_FILE"
echo ". $MAIN_FILENAME" >> "$BASH_FILE"
echo '### END dotfiles MANAGED SECTION' >> "$BASH_FILE"

### Vim Config
if [ "$install_vim" = "1" ]; then
    # Install vim config
    echo "Installing awesome vim config"
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    # Add custom vim config
    echo "Installing custom vim config"
    cp configs/vim_config.vim ~/.vim_runtime/my_configs.vim
fi


### tmux Config
if [ "$install_tmux" = "1" ]; then

    # Install tmux plugin manager
    echo "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Add tmux config file
    echo "Installing tmux config file"
    cp configs/tmux.conf ~/.tmux.conf

    # Install tmux plugins
    echo "Installing tmux plugins"
    bash ~/.tmux/plugins/tpm/bin/install_plugins
fi

#! /bin/bash

# install.sh
# Looks at all files in the dotfiles/ directory and adds them to the current user's .bashrc

MAIN_DIRECTORY="$HOME/.dotfiles"
MAIN_FILENAME="$MAIN_DIRECTORY/.activate"
BASH_FILE="$HOME/.bashrc"

if [[ -d $MAIN_DIRECTORY ]]; then
    echo "Clearing old install.."
    rm -rf $MAIN_DIRECTORY
fi

mkdir $MAIN_DIRECTORY
touch $MAIN_FILENAME

dotfiles_dirs=$( ls "dotfiles")

for dir in $dotfiles_dirs; do
    dotfiles=$(ls dotfiles/$dir)

    for file in $dotfiles; do
        filename="dotfiles/$dir/$file"

        cp $filename $MAIN_DIRECTORY
        new_filename="$MAIN_DIRECTORY/$file"

        echo "Appending $new_filename to $MAIN_FILENAME"
        echo ". $new_filename" >> $MAIN_FILENAME
    done
done

echo "Copying your $BASH_FILE file to /tmp in case of revert"
cp ${BASH_FILE} /tmp/bashrc.bak

echo "Appending $MAIN_FILENAME to user $BASH_FILE"
echo "" >> $BASH_FILE
echo "### BEGIN dotfiles MANAGED SECTION" >> $BASH_FILE
echo ". $MAIN_FILENAME" >> $BASH_FILE
echo '### END dotfiles MANAGED SECTION' >> $BASH_FILE

echo "Sourcing $BASH_FILE"
. $BASH_FILE



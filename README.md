# dotfiles
Convenient place to store your bash profiles and configs.

## Install

### Easy Install

The quickest way to install these dotfiles is to use the `easy_install` script. This one script will do the work of downloading and configuring the dotfiles for your user profile. This avoids having to clone the whole repository to setup the configs.

To perform an install with the `easy_install` script, simply fetch the script from Github

`curl https://raw.githubusercontent.com/nickdibari/dotfiles/master/easy_install.bash > ~/easy_install.bash`

Verify the file contents, then run the script to fetch the dotfiles and save them to your profile

`bash ~/easy_install.bash`

This will install all of the dotfile configs from the repository, plus the `vim` and `tmux` configs.

### From Repository

You can also clone this repository to your machine if you want to make edits to any of the configs before installing them. First, clone this repository:

`git clone https://github.com/nickdibari/dotfiles.git ~/dotfiles`

Next, run the `install.bash` script to load the dotfiles into the current user home directory. You'll need to source your bash profile once the dotfiles have been installed to reload your bash session. The simple install is as follow:

```bash
cd ~/dotfiles
./install.bash
source ~/.bashrc
```

Optionally, you can also install the vim and tmux configs included in the repository. To install the configs for vim and tmux, specify the install options through the command line when running the install script:

```bash
./install.bash --install-vim --install-tmux
```

## Configuring

There are a few configuration options available for your dotfiles setup. You can optionally tweak the behavior of the dotfiles through this file.
These configs should live in a file called `.dotfiles_config` in your home directory. The install scripts will add a line to your `.bashrc` file to load this file if it exists.

The syntax for the file follows the env format for bash scripts, meaning the file should consist of lines in the `key=value` format. An example line for the config file could be

`export config_key="value"`

The options for the config file, including the required type, are:

```
user_prompt_color: (int) ANSI color for the current user in the prompt
host_prompt_color: (int) ANSI color for the hostname in the prompt
```

## Testing

We use [vagrant](https://www.vagrantup.com/) for creating virtual machines to test the install script. This will give you a VM with the dotfiles repository linked to test install the dotfiles on a new machine. To boot the VM, install vagrant from their download page and boot the VM in the repository directory:

`vagrant up dotfiles`

Then, ssh into the machine

`vagrant ssh dotfiles`

You can then `cd` into the dotfiles directory and test the install of this repository by running the install commands.

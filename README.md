# dotfiles
Convenient place to store your bash profiles and configs.

## Install

Run the `install.bash` script to load the dotfiles into the current user home directory. You'll need to source your bash profile once the dotfiles have been installed to reload your bash session. The simple install is as follow:

```bash
./install.bash
source ~/.bashrc
```

Optionally, you can also install the vim and tmux configs included in the repository. To install the configs for vim and tmux, specify the install options through the command line when running the install script:

```bash
./install.bash --install-vim --install-tmux
```

## Testing

We use [vagrant](https://www.vagrantup.com/) for creating virtual machines to test the install script. This will give you a VM with the dotfiles repository linked to test install the dotfiles on a new machine. To boot the VM, install vagrant from their download page and boot the VM in the repository directory:

`vagrant up dotfiles`

Then, ssh into the machine

`vagrant ssh dotfiles`

You can then `cd` into the dotfiles directory and test the install of this repository by running the install commands.

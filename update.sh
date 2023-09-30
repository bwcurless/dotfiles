#!usr/bin/env/ bash
#Create symlinks for all dotfiles
ln -sf dotfiles/.vimrc ~/.vimrc
ln -sf dotfiles/.bashrc ~/.bashrc
ln -sf dotfiles/.gitconfig ~/.gitconfig
ln -sf dotfiles/.tmux.conf ~/.tmux.conf
ln -sf dotfiles/.gitignore_global ~/.gitignore_global
mkdir ~/.docker
ln -sf dotfiles/.docker/config.json ~/.docker/config.json

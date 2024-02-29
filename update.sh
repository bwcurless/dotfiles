#!/usr/bin/bash
#Create symlinks for all dotfiles
# Symlink and force (delete file if it exists and replace with link)
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
mkdir -p ~/.docker
ln -sf ~/dotfiles/.docker/config.json ~/.docker/config.json
mkdir -p ~/.vim/spell
# Link all files here to this target directory
ln -sf ~/dotfiles/spell/* ~/.vim/spell
mkdir -p ~/.vim/UltiSnips
ln -sf ~/dotfiles/UltiSnips/* ~/.vim/UltiSnips

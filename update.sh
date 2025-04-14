#!/usr/bin/bash
#Create symlinks for files
# Symlink and force (delete file if it exists and replace with link)
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.bash_aliases ~/.bash_aliases
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
mkdir -p ~/.docker
ln -sf ~/dotfiles/.docker/config.json ~/.docker/config.json

# Neovim setup
# init.lua, lua/...
ln -sf ~/dotfiles/neovim/* ~/.config/nvim/

mkdir -p ~/.config/nvim/spell
ln -sf ~/dotfiles/spell/* ~/.config/nvim/spell

# Make the folder where snippets are actually stored
mkdir -p ~/.config/nvim/UltiSnips
customSnippetFolder="$HOME/.config/nvim/UltiSnips/"
dotfilesUltiSnipsFolder="$HOME/dotfiles/UltiSnips"
# Copy any new snippets files (non-links) to dotfiles repo
rsync -av --no-links "$customSnippetFolder"  "$dotfilesUltiSnipsFolder" 
# Create links for all files so we get UltiSnipsEdit updates to dotfiles
ln -sf "${dotfilesUltiSnipsFolder}"/* "$customSnippetFolder"

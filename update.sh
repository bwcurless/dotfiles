#!/usr/bin/bash
#Create symlinks for all dotfiles
# Symlink and force (delete file if it exists and replace with link)
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
mkdir -p ~/.docker
ln -sf ~/dotfiles/.docker/config.json ~/.docker/config.json
mkdir -p ~/.vim/spell
# Link all files here to this target directory
ln -sf ~/dotfiles/spell/* ~/.vim/spell
mkdir -p ~/.vim/UltiSnips
# Copy any new snippets files to dotfiles repo
# -n is don't clobber any existing files already
# the /. assures we don't end up with an extra subdirectory being
# copied over
ultiSnipsFolder="$HOME/.vim/UltiSnips/."
dfUltiSnipsFolder="$HOME/dotfiles/UltiSnips"
cp -rn "$ultiSnipsFolder" "$dfUltiSnipsFolder"
ln -sf "${dfUltiSnipsFolder}"/* "$ultiSnipsFolder"

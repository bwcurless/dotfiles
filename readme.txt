Note that the first argument in the symlinks are relative to where the symlink is.
The way it is written at this time, the dotfiles repo needs to be located at ~/dotfiles for
the symlinks to work.

Run this to install the plug manager for vim.

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

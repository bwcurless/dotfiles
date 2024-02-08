# Dotfiles Setup Instructions

Clone this repo to ~/dotfiles
*Note that the first argument in the symlinks are relative to where the symlink is. The way it is written at this time, the dotfiles repo needs to be located at ~/dotfiles for the symlinks to work.*

Run vim. Run ":PlugInstall"

## Programs I've installed
### apt
- git
- htop
- tldr
- python3
- tmux
- docker

### pip
- jupyterlab
- jedi
- scikit-image
- numpy
- matplotlib

## Jupyter Lab Setup
- Install extensions
- jupyterlab-vim
- jupyterlab-lsp
- Make a new venv
    - Create virtual environment ```python3 -m venv venv```
    - Activate venv ```source venv/bin/activate```
    - ```pip install ipykernel```
    - Add venv to jupyter ```python -m ipykernel install --user --name=venv```

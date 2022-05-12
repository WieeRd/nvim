#!/bin/bash

pkglist="
  ctags
  fd
  fzf
  git
  glow
  luarocks
  neovim
  python
  ripgrep
  rust
  sdl2
  sdl2_mixer
  tree-sitter
  xclip
"

piplist="
  black
  pynvim
"

packer_url="https://github.com/wbthomason/packer.nvim"
packer_path="$HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim"


echo "[[ Installing required Pacman packages... ]]"
sudo pacman -S --needed $pkglist
echo

echo "[[ Installing required Python packages... ]]"
pip3 install $piplist
echo

if [ ! -d "$packer_path" ]; then
  echo "[[ Installing packer.nvim plugin manager... ]]"
  git clone --depth 1 $packer_url $packer_path
else
  echo "packer is already installed."
fi
echo

echo "[[ Installing Neovim plugins... ]]"
nvim --headless \
  -c 'autocmd User PackerComplete quitall' \
  -c 'PackerSync'
echo

echo Done!

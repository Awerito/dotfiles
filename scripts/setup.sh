#! /bin/bash

echo "Setup script"

sudo apt remove nano firefox firefox-locale-de firefox-locale-es firefox-locale-it firefox-locale-pt firefox-locale-zh-hans firefox-locale-ar firefox-locale-en firefox-locale-fr firefox-locale-ja firefox-locale-ru firefox-locale-zh-hant -y

sudo apt update && sudo apt upgrade -y

sudo apt install git alacritty stow figlet -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm ~/.zshrc

mkdir -p ~/.local/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf -P ~/.local/share/fonts

ssh-keygen -t ed25519 -C "diego.i.munoz.viveros@gmail.com"

cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo "Add ssh key to https://gitlab.com/"
read "Wait"

git clone git@gitlab.com:Awerito/dotfiles.git .dotfiles

cd ~/.dotfiles

stow --adopt .

cd
echo "Done!"

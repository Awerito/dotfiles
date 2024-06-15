#! /bin/bash

echo "Installer script"
read "Wait"

sudo apt remove nano firefox firefox-locale-de firefox-locale-es firefox-locale-it firefox-locale-pt firefox-locale-zh-hans firefox-locale-ar firefox-locale-en firefox-locale-fr firefox-locale-ja firefox-locale-ru firefox-locale-zh-hant -y

sudo apt install apt-transport-https curl gnupg zsh -y

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install cargo brave-browser vim git vifm alacritty stow figlet -y

cargo install natls

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm ~/.zshrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.bundle/Vundle.vim

mkdir ~/.fonts

wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf -P ~/.fonts

ssh-keygen -t rsa -b 2048 -C "diego.i.munoz.viveros@gmail.com"

cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo "Add ssh key to https://gitlab.com/"
read "Wait"

git clone git@gitlab.com:Awerito/dotfiles.git .dotfiles

cd ~/.dotfiles

stow alacritty vim vifm zsh

vim -c PluginInstall -c qa!

vim -c "call mkdp#util#install()"

cd
echo "Done!"

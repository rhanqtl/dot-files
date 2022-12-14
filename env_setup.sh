#!/usr/bin/env bash

set +ex

function _now() {
  date '+%Y-%m-%d %T'
}

function _green() {
  text=$1
  echo -n "\x1b[32m$text\x1b[0m"
}

function _red() {
  text=$1
  echo -n "\x1b[31m$text\x1b[0m"
}

function _info() {
  msg=$1
  printf "$(_now) $(_green INFO) $msg\n"
}

_project_dir=${PROJECT_DIR:=~/projects}

if [[ ! -d ${_project_dir} ]]; then
  mkdir -p ${_project_dir}
fi

_info 'installing basic development tools'

pacman -S which patch diffutils make git openssh

function _install_yay() {
  _info 'installing yay'
  cd "${_project_dir}"
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
}

_install_yay

### setup shell ###

function _setup_zsh() {
  _info 'installing Oh My Zsh'
  pacman -S zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
  # TODO: register plugins
}

_setup_zsh

function _install_sdks() {
  _info "installing SDK's"

  pacman -S clang lldb cmake

  pacman -S go 
  go env -w GO111MODULE=on
  go env -w GOPROXY=https://goproxy.cn,direct

  pacman -S rustup 
  rustup toolchain install nightly

  pacman -S ocaml opam
  opam init && opam update
  opam install utop
}

_install_sdks

_info 'installing Docker'

pacman -S docker
# TODO: systemd 配置
# /etc/wsl.conf
# [boot]
# systemd = true
systemctl enable --now docker.service

function hq_setup_python() {
  pacman -S ipython
}

function hq_setup_golang() {
  pacman -S go
}

pacman -S which patch diffutils make git openssh sed

# sed -e 's/#zh_CN\.\(UTF-8\|GBK\)/zh_CN.\1/' /etc/locale.gen
# locale-gen

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
  opam install utop dune merlin ocaml-lsp-server odoc ocamlformat ocp-indent
  # TODO: 注意修改 vim 和 emacs 的配置以使用 merlin
  #
}

_install_sdks

_info 'installing Docker'

pacman -S docker
# TODO: systemd 配置
# /etc/wsl.conf
# [boot]
# systemd = true
systemctl enable --now docker.service

function _install_tmux() {
  pacman -S tmux
}

_install_tmux

function _setup_spacemacs() {
  _info 'setting up Spacemacs'
  pacman -S emacs
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
}

_setup_spacemacs


function setup_c++() {
  pacman -S clang clang-extra-tools gtest
}

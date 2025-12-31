#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"
NVIM_CFG_SRC="${DOTFILES_DIR}/nvim"
NVIM_CFG_DST="${HOME}/.config/nvim"

have() { command -v "$1" >/dev/null 2>&1; }

# 1) 确保基础工具
if ! have git; then
  echo "[dotfiles] git not found. Please install git in the image."
  exit 1
fi

if ! have curl; then
  if have apt-get; then
    sudo apt-get update && sudo apt-get install -y curl ca-certificates
  elif have apk; then
    sudo apk add --no-cache curl ca-certificates
  else
    echo "[dotfiles] curl not found and no known package manager."
    exit 1
  fi
fi

# 2) 安装 nvim（二进制）
if ! have nvim; then
  echo "[dotfiles] installing neovim..."

  # 优先：下载官方 release（适用于大多数 Debian/Ubuntu devcontainer）
  if have uname && [ "$(uname -s)" = "Linux" ] && have tar; then
    tmp="$(mktemp -d)"
    curl -L -o "${tmp}/nvim.tar.gz" \
      https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo mkdir -p /opt
    sudo tar -C /opt -xzf "${tmp}/nvim.tar.gz"
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm -rf "${tmp}"
  elif have apt-get; then
    sudo apt-get update && sudo apt-get install -y neovim
  elif have apk; then
    sudo apk add --no-cache neovim
  else
    echo "[dotfiles] cannot install nvim automatically (no supported method)."
    exit 1
  fi
fi

# 3) 链接你的 nvim 配置
mkdir -p "${HOME}/.config"
ln -sfn "${NVIM_CFG_SRC}" "${NVIM_CFG_DST}"
echo "[dotfiles] linked ${NVIM_CFG_DST} -> ${NVIM_CFG_SRC}"

# 4) 自动装插件（LazyVim/lazy.nvim）
#    容器网络慢的话，你之前加的 git.timeout 也会生效
echo "[dotfiles] syncing plugins (headless)..."
nvim --headless "+Lazy! sync" +qa || true

echo "[dotfiles] done"

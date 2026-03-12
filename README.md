# Dotfiles

This repository contains my terminal-focused macOS setup built around Homebrew, zsh, tmux, Yazi, and Neovim.

The instructions below assume that Homebrew is already installed and that this repository will be cloned to `~/.config`.  
Applications that read from `~/.config/<app>` will use these files directly.  
Only tools that expect files in the home directory require symbolic links.

## Setup

```bash
# Step 1 : Clone this repository into ~/.config
git clone https://github.com/DS-argus/dotfiles.git ~/.config

# Step 2 : Install terminal emulator. (one of them below)
## Terminal emulator: Ghostty
brew install --cask ghostty

## Terminal emulator and multiplexer: WezTerm
brew install --cask wezterm
ln -sfn ~/.config/wezterm/.wezterm.lua ~/.wezterm.lua

# Step 3 : Install terminal multiplexer
## Terminal multiplexer
brew install tmux
ln -sfn ~/.config/tmux/.tmux.conf ~/.tmux.conf

## tmux plugin manager required by the current tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Step 4 : Utilities
## Prompt: Starship
brew install starship

## Smarter cd replacement used by zsh
brew install zoxide

## Fuzzy finder used by shell workflows and Yazi
brew install fzf

## Extra zsh completions
brew install zsh-completions

## zsh syntax highlighting
brew install zsh-syntax-highlighting

## zsh command autosuggestions
brew install zsh-autosuggestions

## zsh entrypoint files expected in the home directory
ln -sfn ~/.config/zsh/.zshrc ~/.zshrc
ln -sfn ~/.config/zsh/.zshenv ~/.zshenv

## Modern ls replacement used by shell aliases
brew install eza

## Better cat replacement with syntax highlighting
brew install bat

## Terminal Markdown renderer
brew install glow

## Terminal image renderer, also used by Yazi interactive openers
brew install chafa

## CSV viewer
brew install csvlens

## Resource monitor
brew install btop

## Homebrew TUI
brew install gromgit/brewtils/taproom

## Git TUI
brew install lazygit

## GitHub CLI
brew install gh
gh auth login

## GitHub dashboard extension for gh
gh extension install dlvhdr/gh-dash

## Yazi and its Homebrew-side dependencies
### file(1) is also required by Yazi, but it is already available on macOS
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font
### yazi: file manager itself
### ffmpeg: video thumbnails and preview
### sevenzip: archive extraction and preview
### jq: JSON preview
### poppler: PDF preview
### fd: file name search
### ripgrep: file content search
### fzf: quick subtree navigation
### zoxide: historical directory navigation, often combined with fzf
### resvg: SVG preview
### imagemagick: font, HEIC, and JPEG XL preview
### font-symbols-only-nerd-font: Nerd Font symbols for terminal icons

## Yazi plugins and flavors declared in package.toml
ya pkg install

## Python package and project manager
brew install uv

## Main editor
brew install neovim

## Home-directory config files that should point into this repository
ln -sfn ~/.config/git/.gitconfig ~/.gitconfig
```

## Notes

The following applications read their configuration directly from this repository without additional symlinks:  
Ghostty, btop, gh, gh-dash, Neovim, Starship, and Yazi.

## References

- git: https://johngrib.github.io/wiki/git-alias/
- nvim: https://youtu.be/6pAG3BHurdM?si=AzUMnrt0LlFBmmLY
- starship: https://starship.rs/
- tmux: https://youtu.be/U-omALWIBos?si=SSd_mR2AfuQRy3wVj
- wezterm: https://wezfurlong.org/wezterm/index.html
- yazi: https://yazi-rs.github.io/

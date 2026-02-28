# dotfiles

All of my configuration files.

Here are the symlinks for each config file or directory.

```zsh
# kitty
ln -s ~/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

```zsh
# lazygit
ln -s ~/dotfiles/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
```

```zsh
# neovim
ln -s ~/dotfiles/nvim ~/.config/nvim
```

```zsh
# yabai
ln -s ~/dotfiles/yabai ~/.config/yabai
```

```zsh
# skhd
ln -s ~/dotfiles/skhd ~/.config/skhd
```

```zsh
# zshrc
ln -s ~/dotfiles/zshrc/.zshrc ~/.zshrc
```

Feburary 28, 2026 -- There have been some issues regarding yabai-v7.1.17 set up (specifically workspace navigation commands) on macOS Taheo 26.3. The issue was resolved when yabai was downgraded to yabai-v7.1.16.

```zsh
# yabai downgrade

mkdir -p $(brew --repository)/Library/Taps/local/homebrew-yabai/Formula

curl https://raw.githubusercontent.com/asmvik/homebrew-formulae/c9fc60dcb9746ae35a08e1fa8e6eaa2f604a3b92/yabai.rb \\n  -o $(brew --repository)/Library/Taps/local/homebrew-yabai/Formula/yabai.rb
```



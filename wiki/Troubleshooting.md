# 🐛 Dépannage
Guide aux problèmes courants.

## 📋 Table des matières

1. [Installation](#installation)
2. [Zsh](#zsh)
3. [Tmux](#tmux)
4. [asdf](#asdf)
5. [Performance](#performance)
6. [Diagnostics](#diagnostics)

---

## 🚀 Installation

**Permission denied :**
```bash
chmod +x bootstrap.sh && ./bootstrap.sh
```

**git/curl absents :**
```bash
# macOS
xcode-select --install

# Arch
sudo pacman -S git curl
```

**Fichiers existent déjà :**
```bash
mv ~/.zshrc ~/.zshrc.backup
./bootstrap.sh
```

---

## 🐚 Zsh

**Shell par défaut :**
```bash
chsh -s $(which zsh)
```

**Complétions cassées :**
```bash
rm -f ~/.cache/zsh/.zcompdump*
exec zsh
```

**Zinit ne charge pas :**
```bash
rm -rf ~/.local/share/zinit
exec zsh
```

**Historique vide :**
```bash
mkdir -p ~/.local/state/zsh
echo $HISTFILE
```

**Shell lent :**
```bash
time zsh -i -c exit
rm -rf ~/.cache/zsh/*
```

---

## 🖥️ Tmux

**Protocol version mismatch :**
```bash
tmux kill-server && tmux
```

**Plugins absents :**
```bash
rm -rf ~/.config/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Dans Tmux : ctrl+space I
```

**Couleurs incorrectes :**
```bash
echo $TERM  # Doit être tmux-256color
export TERM="xterm-256color"
```

---

## 🔧 asdf

**Command not found :**
```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
exec zsh
```

**Plugin ne s'installe pas :**
```bash
asdf update
asdf plugin add nodejs
```

---

## ⚡ Performance

**Shell lent :**
```bash
rm -rf ~/.cache/zsh/*
rm -rf ~/.local/share/zinit/.zi0
```

**Tmux lent :**
```bash
# Réduire historique dans ~/.config/tmux/options.conf
set -g history-limit 10000
```

---

## 🔍 Diagnostics

**Logs :**
```bash
cat ~/.dotfiles/install.log
grep "❌" ~/.dotfiles/install.log
```

**Réinstaller :**
```bash
cd ~/.dotfiles && git pull && ./bootstrap.sh
```

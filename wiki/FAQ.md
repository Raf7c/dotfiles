# ❓ FAQ

Questions fréquentes.

---

## 🖥️ Compatibilité

### Quel système est supporté ?

**macOS uniquement** (12.0+)
- Apple Silicon (M1/M2/M3/M4)
- Intel

### Puis-je utiliser sur Linux ?

Non, ce dotfiles est optimisé pour macOS uniquement.

---

## 📦 Installation

### Combien de temps prend l'installation ?

**3-10 minutes** selon votre connexion internet.

### Puis-je relancer l'installation ?

Oui ! Le script est **idempotent** - sûr de relancer plusieurs fois.

```bash
cd ~/.dotfiles
./bootstrap.sh
```

### Que fait bootstrap.sh exactement ?

1. Crée les liens symboliques
2. Installe Homebrew et paquets
3. Migre l'historique shell
4. Installe TPM pour Tmux
5. Configure asdf
6. Applique les préférences macOS
7. Génère le cache GCC

### Quelle est la différence entre bootstrap.sh et update.sh ?

| Script | Usage | Homebrew |
|--------|-------|----------|
| `bootstrap.sh` | Installation initiale | Installe les paquets manquants |
| `update.sh` | Mise à jour | Met à jour **tous** les paquets |

**Utilisez `update.sh` pour :**
- Mettre à jour Homebrew et tous les paquets
- Mettre à jour les sous-modules (Neovim)
- Mettre à jour asdf, Tmux, Zinit
- Récupérer les dernières modifications du dépôt

```bash
cd ~/.dotfiles
./update.sh
```

---

## ⚙️ Configuration

### Comment ajouter un alias ?

```bash
vim ~/.config/shell/aliases
# Ajouter : alias mon_alias="ma_commande"
source ~/.zshrc
```

### Comment changer le prompt ?

```bash
vim ~/.config/starship.toml
exec zsh
```

### Où sont mes fichiers de config ?

Tout est dans `~/.dotfiles/.config/`

---

## 🐚 Shell

### Comment changer le shell par défaut ?

```bash
chsh -s $(which zsh)
# Redémarrer le terminal
```

### Le shell est lent au démarrage

```bash
# Tester le temps
time zsh -i -c exit

# Devrait être < 0.2s
# Si plus lent, vérifier les plugins
```

### Comment désactiver un plugin Zsh ?

```bash
vim ~/.dotfiles/zsh/zinit.zsh
# Commenter la ligne du plugin
exec zsh
```

---

## 🖥️ Tmux

### Comment installer les plugins Tmux ?

```bash
tmux
# Puis : Ctrl+Space + I (majuscule)
```

### Le préfixe Tmux ne fonctionne pas

Le préfixe est `Ctrl+Space` (pas `Ctrl+b`)

### Comment changer le thème Tmux ?

```bash
vim ~/.config/tmux/tmux.conf
# Changer la ligne source-file
```

---

## 🔧 Outils

### Comment mettre à jour les paquets ?

```bash
cd ~/.dotfiles
./bootstrap.sh
```

### asdf ne fonctionne pas

```bash
# Vérifier l'installation
asdf --version

# Réinstaller
sh ~/.dotfiles/src/setup/asdf.sh
```

### Homebrew introuvable

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

---

## 🎨 Personnalisation

### Comment changer les couleurs ?

Le thème Catppuccin est intégré partout. Pour changer :

```bash
# Ghostty
vim ~/.config/ghostty/config

# Tmux
vim ~/.config/tmux/tmux.conf

# Neovim
# Géré dans le submodule nvim
```

### Comment ajouter un paquet Homebrew ?

```bash
# Éditer le Brewfile
vim ~/.dotfiles/Brewfile

# Ajouter : brew "nom_paquet"

# Installer
brew bundle --file=~/.dotfiles/Brewfile
```

---

## 🐛 Problèmes

### Permission denied

```bash
chmod +x ~/.dotfiles/bootstrap.sh
```

### Les liens symboliques ne fonctionnent pas

```bash
cd ~/.dotfiles
sh src/setup/link_global.sh
```

### Zinit ne charge pas

```bash
rm -rf ~/.local/share/zinit
exec zsh
```

### Les plugins Tmux ne s'installent pas

```bash
rm -rf ~/.config/tmux/plugins/tpm
sh ~/.dotfiles/src/setup/tmux.sh
# Dans Tmux : Ctrl+Space + I
```

---

## 🔄 Mises à jour

### Comment mettre à jour les dotfiles ?

```bash
cd ~/.dotfiles
git pull
./bootstrap.sh
```

### Comment mettre à jour Neovim config ?

```bash
cd ~/.dotfiles
git submodule update --remote --merge
```

---

**Besoin d'aide ?** → [Ouvre une issue](https://github.com/Raf7c/dotfiles/issues)

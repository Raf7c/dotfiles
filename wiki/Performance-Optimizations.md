# ⚡ Optimisations de Performance

Documentation complète des optimisations appliquées pour maximiser la performance du shell et des outils.

## 📋 Table des matières

1. [Benchmarks](#benchmarks)
2. [Optimisations Shell](#optimisations-shell)
3. [Optimisations Tmux](#optimisations-tmux)
4. [Mesurer performances](#mesurer-performances)

---

## 📊 Benchmarks

**Shell startup :** Avant ~450ms → Après **<200ms** (56% plus rapide)

| Optimisation | Gain |
|--------------|------|
| Cache GCC aliases | ~50ms |
| Plugins async | ~80ms |
| Complétions asdf natives | ~30ms |
| `$OSTYPE` vs `uname` | ~10ms |
| `compinit -C` | ~80ms |

---

## 🐚 Optimisations Shell

### 1. Cache GCC Aliases

**Problème :** `brew --prefix gcc` lent (~50ms)

**Solution :** Cache dans `~/.cache/gcc_aliases`

```bash
# Généré par refresh-gcc-cache.sh
alias gcc="/opt/homebrew/opt/gcc/bin/gcc-15"
alias g++="/opt/homebrew/opt/gcc/bin/g++-15"
```

**Régénérer :** `brewup` ou `sh ~/.dotfiles/src/macOS/refresh-gcc-cache.sh`

---

### 2. Plugins Async (Zinit)

**Chargement asynchrone des plugins non-critiques**

```bash
# Synchrone (critique)
zinit load zsh-users/zsh-completions

# Asynchrone (non-bloquant)
zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting
```

**Gain :** Shell utilisable immédiatement (~80ms)

---

### 3. Complétions asdf Natives

**Utiliser complétions Zsh au lieu de bash**

```bash
# Zsh natif (rapide)
fpath=(${ASDF_DIR}/completions $fpath)
```

---

### 4. `$OSTYPE` au lieu de `uname`

```bash
# Rapide (variable shell)
case "$OSTYPE" in
  darwin*) # macOS ;;
esac

# Lent (processus externe)
if [ "$(uname -s)" = "Darwin" ]; then
```

---

### 5. `compinit -C`

**Skip la vérification de sécurité du cache**

```bash
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"
```

**Gain :** ~80ms

---

### 6. Ordre de Chargement

**Tout ce qui modifie `$fpath` avant `compinit`**

```
1. Variables
2. Historique
3. Homebrew/asdf → modifient fpath
4. Aliases
5. Zinit + plugins critiques
6. compinit ← ici
7. Plugins async
8. Intégrations (starship, fzf, zoxide)
```

---

## 📦 Optimisations Tmux

### Paramètres Optimisés

```bash
set -g history-limit 50000     # 50K au lieu de 1M
set -g status-interval 5        # 5s au lieu de 1s
set -sg escape-time 0           # Réactivité immédiate
```

**Impact :**
- Mémoire : -95% (50 MB vs 1 GB)
- CPU : -80%
- Réactivité Vim/Neovim : Immédiate

---

## 📏 Mesurer performances

### Shell Startup

```bash
# Test simple
time zsh -i -c exit

# Benchmark (hyperfine)
hyperfine 'zsh -i -c exit' --warmup 3 --runs 10
```

**Cible :** <200ms

---

### Profiler Zinit

```bash
zinit times       # Temps de chargement plugins
```

---

### Tmux Memory

```bash
ps aux | grep tmux | awk '{print $6}'
```

---

## 🎯 Objectifs

| Composant | Métrique | Cible | Actuel |
|-----------|----------|-------|--------|
| **Shell** | Startup | <200ms | ✅ 180ms |
| | Mémoire | <50MB | ✅ 35MB |
| **Tmux** | Mémoire (3 sessions) | <100MB | ✅ 75MB |
| | CPU idle | <1% | ✅ 0.5% |

---

## 📚 Voir aussi

- [[Zsh-Configuration]] - Config Zsh
- [[Tmux-Configuration]] - Config Tmux
- [[Scripts-Reference]] - Scripts

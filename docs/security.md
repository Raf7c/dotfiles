# Sécurité

Les clés, la signature des commits, les secrets.

## L'essentiel

| Question | Réponse |
|---|---|
| Où sont les clés privées ? | sur les YubiKeys, jamais sur disque |
| Qu'est-ce qui est versionné ? | `allowed_signers`, des clés **publiques** |
| Où est `~/.ssh/config` ? | dans un dépôt privé séparé |
| Y a-t-il une config sops ici ? | non, aucune |
| Sans la YubiKey ? | les commits échouent — [voir plus bas](#sans-la-yubikey) |
| Un commit ne se vérifie pas ? | [Vérifier que ça marche](#vérifier-que-ça-marche), les quatre contrôles |

Ce dépôt est public. Rien de secret n'y est versionné.

<details>
<summary>Ce qui vit ici, et ce qui vit ailleurs</summary>

| Vit ici | Vit ailleurs |
|---|---|
| le **paramétrage** de la signature (`gpg.format`, quel `ssh-keygen`, quel fichier allowed_signers) | les clés **privées** : elles ne quittent jamais la YubiKey |
| `allowed_signers` — des clés **publiques**, versionnées à dessein | `~/.ssh/config`, dans un dépôt privé séparé |
| une variable de durcissement, `SOPS_HC_VAULT_ALLOWLIST` | toute configuration sops : ce dépôt n'en porte aucune |
| les planchers de version, et la méthode pour les réviser | `config.local`, généré par machine et gitignoré |

</details>

## Les clés

Deux YubiKeys. La première porte les trois identifiants FIDO2, un par usage,
et sert à tout au quotidien.

| Fichier | Droit | Présence |
|---|---|---|
| `~/.ssh/id_signing_sk` | signer, sur les **deux** forges | sans toucher, sans PIN |
| `~/.ssh/github_sk` | push GitHub | PIN |
| `~/.ssh/gitlab_sk` | push GitLab | PIN |

La seconde est un **secours pour sops** : elle porte une identité age, et elle
est rangée ailleurs que la première. Elle ne porte aucun des trois identifiants
ci-dessus, donc elle ne remplace pas la première pour signer ni pour pousser.

> [!CAUTION]
> PIV et FIDO2 sont deux applications séparées sur la clé. `ykman piv reset` ne
> répare **aucun** problème de signature ni de push, et il efface l'identité age
> de la clé, définitivement.

<details>
<summary>Pourquoi une clé pour signer et deux pour pousser</summary>

`-O application=…` donne à chaque identifiant son espace de noms. C'est ce qui
leur permet de coexister sur une seule clé. Révoquer l'un ne touche pas les
autres.

**Signer : une clé pour deux forges.** Une signature n'est pas un accès. La
même signature prouve la même chose des deux côtés. Il n'y a rien à cloisonner.

**Pousser : deux clés.** Perdre l'accès à une forge ne doit jamais coûter
l'accès à l'autre.

</details>

<details>
<summary>Le risque accepté : pas de contact physique pour signer</summary>

La clé de signature porte `-O no-touch-required`.

Ce qui est abandonné : la preuve de présence. Un malware sur une machine
déverrouillée, clé branchée, peut signer sans bruit. La vérification ne peut
pas s'en apercevoir, car `allowed_signers` n'a aucun champ de toucher.

Ce qui le justifie : la signature se déclenche à chaque commit. Les deux clés
d'authentification, elles, exigent toujours un PIN. Le droit le plus fort garde
la garde la plus forte.

</details>

## Procédures

### Récupérer les clés sur une machine neuve

Les identifiants résidents ne se copient pas. Ils se redérivent depuis la clé.

```sh
cd ~/.ssh && ssh-keygen -K
mv id_ed25519_sk_rk_github      github_sk
mv id_ed25519_sk_rk_github.pub  github_sk.pub
mv id_ed25519_sk_rk_gitlab      gitlab_sk
mv id_ed25519_sk_rk_gitlab.pub  gitlab_sk.pub
mv id_ed25519_sk_rk_signing     id_signing_sk
mv id_ed25519_sk_rk_signing.pub id_signing_sk.pub
chmod 600 github_sk gitlab_sk id_signing_sk
chmod 644 github_sk.pub gitlab_sk.pub id_signing_sk.pub

cd ~/.dotfiles && ./run install gitsign
```

`ssh-keygen -K` récupère les trois identifiants d'un coup. Le `./run install
gitsign` final active la signature.

> [!IMPORTANT]
> Ça vient **après** `./run install`. L'`ssh-keygen` capable de parler à une
> clé FIDO2 est celui de Homebrew, et c'est l'installation qui le pose.

<details>
<summary>Pourquoi ces renommages</summary>

Le suffixe `_rk_<nom>` vient de l'espace de noms `-O application=ssh:<nom>`
donné à la création. C'est pour ça que les trois reviennent distinguables.

Seul `id_signing_sk` est un nom que quelque chose cherche tout seul.
`github_sk` et `gitlab_sk` doivent être pointés par `~/.ssh/config`. Sinon ssh
retombe sur les noms par défaut et la connexion est refusée.

</details>

<details>
<summary>Créer les clés depuis zéro, drapeau par drapeau</summary>

```sh
/opt/homebrew/opt/openssh/bin/ssh-keygen -t ed25519-sk -O resident \
  -O no-touch-required -O application=ssh:signing \
  -C "signing-yubikey" -f ~/.ssh/id_signing_sk

/opt/homebrew/opt/openssh/bin/ssh-keygen -t ed25519-sk -O resident \
  -O verify-required -O application=ssh:github \
  -C "github-yubikey" -f ~/.ssh/github_sk

/opt/homebrew/opt/openssh/bin/ssh-keygen -t ed25519-sk -O resident \
  -O verify-required -O application=ssh:gitlab \
  -C "gitlab-yubikey" -f ~/.ssh/gitlab_sk
```

Le chemin Homebrew complet, parce que l'`ssh-keygen` d'Apple ne sait pas créer
de clés `sk-*`. `-O resident` stocke l'identifiant sur la YubiKey : c'est ce
qui rend la récupération ci-dessus possible, sans jamais transférer de fichier.

</details>

### Enregistrer les clés sur chaque forge

| Forge | Clé | Où |
|---|---|---|
| GitHub | `id_signing_sk.pub` | liste **Signing key** |
| GitHub | `github_sk.pub` | liste **Authentication key** |
| GitLab | `id_signing_sk.pub` | *Usage type* = `Signing` |
| GitLab | `gitlab_sk.pub` | *Usage type* = `Authentication` |

GitLab n'a qu'une seule liste, avec un menu *Usage type*. Une clé laissée sur
`Authentication` ne fera pas vérifier les signatures.

L'adresse de `config.gitlab` doit être un email **vérifié** sur le compte.
Sinon le commit reste non rattaché. La raison est dans la section
**Référence**, repli « Ce qu'une signature prouve ».

Puis `~/.ssh/config`, qui vit dans un dépôt privé :

```sshconfig
IgnoreUnknown UseKeychain

Host github.com
  IdentityFile ~/.ssh/github_sk
  IdentitiesOnly yes
  AddKeysToAgent no
  IdentityAgent none

Host gitlab.com
  IdentityFile ~/.ssh/gitlab_sk
  IdentitiesOnly yes
  AddKeysToAgent no
  IdentityAgent none
```

<details>
<summary>Pourquoi ces quatre lignes par hôte</summary>

`AddKeysToAgent no` et `IdentityAgent none` : l'ssh-agent de macOS ne sait pas
parler aux clés de sécurité et refuse de signer (`agent refused operation`).
On le contourne pour parler directement à l'authentificateur.

`IgnoreUnknown UseKeychain` en tête : l'openssh de brew n'est pas keg-only, son
`ssh` masque celui d'Apple et ne connaît pas `UseKeychain`. Sans cette ligne,
chaque connexion échoue sur un mot-clé inconnu.

La signature, elle, ne demande aucun réglage : `gitsign` trouve
`~/.ssh/id_signing_sk.pub` tout seul et écrit `config.local`.

</details>

### Sans la YubiKey

Deux cas, et un seul est confortable.

| Situation | Ce qui se passe |
|---|---|
| Machine qui n'a **jamais** vu la clé | commits non signés, rien n'échoue |
| Machine installée **avec** la clé, puis clé partie | **chaque commit échoue** |

Le second donne `Couldn't sign message: device not found?` puis
`fatal: failed to write commit object`. Rien n'est écrit, le dépôt ne bouge pas.

> [!IMPORTANT]
> **Relancer `./run install gitsign` ne débloque pas.** L'étape teste la
> présence de `~/.ssh/id_signing_sk.pub`, un talon qui reste sur le disque
> quand la clé est dans une poche. C'est un choix : la signature est une
> politique, pas une commodité.

Sortie de secours, pour un commit :

```sh
git -c commit.gpgsign=false commit -m "…"
```

Pour un dépôt entier, le temps que la clé revienne :

```sh
git config --local commit.gpgsign false
```

La config du dépôt l'emporte sur `config.local`, qui est globale. À retirer au
retour de la clé. Les commits déjà écrits ne changent pas.

### Faire tourner la clé de signature

Garder les **deux** clés, chacune avec sa fenêtre :

```text
me@example  namespaces="git",valid-before="20260804"  sk-ssh-ed25519@openssh.com AAAA…old
me@example  namespaces="git",valid-after="20260804"   sk-ssh-ed25519@openssh.com AAAA…new
```

Chaque commit est vérifié par la clé valide à sa date. Retirer l'ancienne ligne
et ses commits cessent de se vérifier.

> [!NOTE]
> C'est assumé ici : aucune ligne ne couvre les commits signés entre le
> 2026-07-27 et le 2026-08-04, qui ne se vérifient donc pas.

### Perdre la YubiKey

Celle du quotidien. Les trois identifiants sont dessus et nulle part
ailleurs — la clé de secours ne les porte pas. Rien à effacer sur les machines.
Dans cet ordre :

1. **Révoquer les deux clés d'authentification.** Retirer `github_sk.pub` de
   GitHub et `gitlab_sk.pub` de GitLab. Tant qu'elles y sont, celui qui tient
   la clé peut pousser ; le PIN est la seule chose sur son chemin.
2. **Laisser la clé de signature enregistrée.** La retirer ferait retomber en
   Unverified tout ce qu'elle a signé.
3. Créer trois identifiants sur la clé de remplacement, les envoyer, et ajouter
   la nouvelle clé de signature à `allowed_signers` avec un `valid-after`.

`allowed_signers` ne demande aucune suppression : une ligne dont la fenêtre est
fermée vérifie encore les vieux commits et ne peut plus rien signer de neuf.

## Vérifier que ça marche

Quatre choses peuvent être fausses séparément. À tester dans cet ordre.

| # | Ce qu'on teste | Commande |
|---|---|---|
| 1 | l'identité | `git config user.email` dans un dépôt |
| 2 | l'accès | `ssh -T git@github.com` puis `ssh -T git@gitlab.com` |
| 3 | la signature | `git verify-commit HEAD` dans un dépôt jetable |
| 4 | `allowed_signers` | le `grep -cF` ci-dessous, qui doit rendre **2** |

```sh
grep -cF "$(cut -d' ' -f2 ~/.ssh/id_signing_sk.pub)" ~/.config/git/allowed_signers
```

Deux, parce qu'il y a un principal par identité pour une seule clé.

Un échec au n°3 vient presque toujours de trois choses : pas
d'`allowedSignersFile`, la clé absente d'`allowed_signers`, ou un commit
antérieur au `valid-after` de sa ligne.

<details>
<summary>Les quatre contrôles en détail</summary>

**1. L'identité suit l'URL du remote, pas le répertoire.**

```sh
cd ~/lab/github/anything  && git config user.email
cd ~/lab/gitlab/anything  && git config user.email
cd /tmp && git init -q gl-test && cd gl-test \
  && git remote add origin git@gitlab.com:racongiu/x.git \
  && git config user.email
```

Le troisième cas est celui qui compte : hors de `~/lab`, l'identité GitLab
s'applique quand même ([.config/git/README.md](../.config/git/README.md)).

**2. Deux exécutions, parce que ce sont deux identifiants séparés.** Un succès
sur l'un ne dit rien de l'autre.

**3. De bout en bout, dans un dépôt jetable :**

```sh
cd /tmp && rm -rf sigtest && mkdir sigtest && cd sigtest && git init -q .
git commit -q --allow-empty -m test
git verify-commit HEAD
git log --show-signature -1
```

`verify-commit` doit rendre 0, et `log` afficher `Good "git" signature`.

</details>

## Référence

Ces sections se consultent, elles ne se lisent pas d'un bout à l'autre.

<details>
<summary>Ce qu'une signature prouve, et ce qu'elle ne prouve pas</summary>

Mesuré, parce que le modèle intuitif est faux.

| Où | Ce qui décide |
|---|---|
| en local | la **clé** : `find-principals` renvoie la première ligne qui la porte |
| sur la forge | l'**email** du commit, pas la clé |
| fenêtres | `valid-after` / `valid-before`, contre la date du **commit** |

L'email du committer ne joue aucun rôle en local. Le principal n'est que le nom
que git réaffiche.

Sur la forge, une adresse inconnue laisse le commit non rattaché, quoi que la
signature prouve en local.

Donc un commit peut se vérifier en local et rester Unverified sur la forge, ou
l'inverse. Ce sont deux questions différentes.

</details>

<details>
<summary>Secrets : sops et age</summary>

L'outillage vient du Brewfile ([outils.md](outils.md)).

**Ce dépôt ne porte aucune configuration sops.** Pas de `.sops.yaml`, aucun
destinataire age, aucun fichier chiffré. Il installe l'outillage et durcit une
variable, rien de plus.

Les usages de sops vivent ailleurs. Les clés qui déchiffrent sont les deux
YubiKeys ([Les clés](#les-clés)).

Le seul durcissement porté ici, dans `.config/shell/env.sh` :

```sh
export SOPS_HC_VAULT_ALLOWLIST="none"
```

[GHSA-jgf3-f6rg-8x3h](https://github.com/getsops/sops/security/advisories/GHSA-jgf3-f6rg-8x3h)
(High) : déchiffrer un fichier sops non fiable dont les métadonnées nomment un
`vault_address` fait envoyer le token Vault local vers cet hôte.

L'avis n'a **aucune version corrigée**. 3.13.0+ plus cette variable EST le
correctif, et son défaut est `all`, donc aucune restriction. `none` énonce la
vérité sur ces machines : elles ne parlent jamais à Vault ni à OpenBao. Le
réglage ne coûte rien et ferme un avis High sans correctif.

</details>

<details>
<summary>Frontières de privilège</summary>

Le shell ne demande **jamais** root ([architecture.md](architecture.md)).
L'installation ne le demande que dans deux étapes sur dix, détaillées dans
[installer.md](installer.md).

Rien ici ne fait rejoindre un groupe privilégié. Les deux moteurs de conteneurs
tournent dans une VM, sous l'identité de l'utilisateur. Le piège du groupe
`docker`, qui vaut root sur Linux, n'a pas d'équivalent ici.

</details>

<details>
<summary>Code tiers</summary>

La plus grosse surface d'exécution du dépôt est décrite par la politique sur le
code tiers d'[architecture.md](architecture.md) : ce qui est cloné à HEAD,
pourquoi ce n'est pas épinglé, et ce que ça coûte.

La seule chose à retenir ici : du code nouveau n'arrive que sur une
installation fraîche ou sur `./run upgrade`, tous deux déclenchés à la main.

</details>

<details>
<summary>Les backups sont en clair</summary>

Où ils vont : [installer.md](installer.md). Ce qui les concerne ici :

- ils ne sont pas chiffrés ;
- les répertoires sont créés avec l'umask du processus ;
- un fichier sauvegardé garde son mode, puisqu'il est **déplacé**.

La migration d'historique déplace `~/.bash_history`, `~/.zsh_history`,
`~/.lesshst` et `~/.python_history` sous `~/.local/state`. L'historique de
shell, c'est là qu'atterrit un secret tapé au prompt. Si `$HOME` est partagé,
ou emporté dans un backup hors de contrôle, c'est le fichier auquel penser en
premier.

Rien ne relit ces répertoires après coup. En supprimer un ne casse rien.

</details>

## Planchers de version

**Un** seul plancher, et c'est une donnée périssable.

| Outil | Plancher | Vérifier |
|---|---|---|
| tmux | **3.6b** | `tmux -V` |

Vérifié le **2026-09-12**. Le silence ici veut dire « pas regardé depuis »,
jamais « rien à trouver ».

> [!IMPORTANT]
> Réviser ce plancher **et sa date** à chaque passage. Un plancher jamais
> révisé devient du folklore.
>
> Lire un avis à ses **deux** adresses : `github.com/advisories/<id>` et
> `github.com/<org>/<repo>/security/advisories/<id>`. L'une comme l'autre peut
> être la seule à l'avoir. Une page de listing ne prouve rien : seule l'URL
> directe d'un identifiant fait preuve.

<details>
<summary>Pourquoi tmux 3.6b, et pourquoi un seul plancher</summary>

Un plancher est un nombre maintenu à la main. Il n'en existe un que là où un
avis le justifie. Ce qui tient les versions à jour partout ailleurs, c'est
`./run upgrade`, qui déplace les binaires.

Pas l'avertissement « version available » de mise : il n'apparaît que sur
`mise --version`, `version` et `doctor`, que rien ici n'appelle. Et aucun
nombre ne dit si être en retard est *dangereux*. Ça demande un humain qui lit
les avis.

**tmux 3.6b.** CVE-2026-11623, un use-after-free Sixel classé Low, CVSS 1.1,
accès local et complexité élevée. Ce plancher n'est pas une urgence, il est
gratuit. Et il est la seule chose qui ferme le trou : `allow-passthrough` ne
garde pas Sixel, l'amont analyse l'image avant de lire cette option.

[GHSA-4cw9-jpqf-99x8](https://github.com/advisories/GHSA-4cw9-jpqf-99x8) nomme
le patch `fc6d94a9` et « 3.7-rc », et rien d'autre. Ses *patched versions* sont
*Unknown* et il ne parle pas de 3.6b.

Le rétroportage se lit dans le **code**, pas dans l'avis. `image_free` passe de
`TAILQ_REMOVE(&s->images, im, entry)` en 3.6a à `TAILQ_REMOVE(im->list, im,
entry)` en 3.6b comme en 3.7. Un rétroportage étant un cherry-pick,
l'ascendance du commit ne prouve rien ; la comparaison du code, si.

Donc 3.6b, ou n'importe quoi en 3.7 et au-dessus, est sûr. 3.6a et en dessous
ne l'est pas. La série publiée va jusqu'à 3.7c, et 3.8-rc existe, vérifié
contre `git ls-remote`.

`tmux display -p '#{sixel_support}'` dit si le binaire embarque Sixel tout
court.

</details>

---

Voir aussi : [.config/git/README.md](../.config/git/README.md) pour la
mécanique git dans laquelle ces clés se branchent, [outils.md](outils.md) pour
la provenance de l'outillage, et [installer.md](installer.md) pour ce que
l'étape `gitsign` écrit.

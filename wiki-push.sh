#!/bin/bash
# ==========================================
# wiki-push.sh
# Synchronizes local wiki to GitHub Wiki
# ==========================================

set -e

WIKI_REPO="$HOME/dotfiles.wiki"
WIKI_SOURCE="$HOME/.dotfiles/wiki"

echo "📚 Syncing wiki..."

# Clone the wiki if needed
if [ ! -d "$WIKI_REPO" ]; then
    echo "🔽 Cloning GitHub wiki..."
    git clone git@github.com:Raf7c/dotfiles.wiki.git "$WIKI_REPO"
fi

# Update the wiki repo
cd "$WIKI_REPO"
echo "🔄 Fetching latest changes..."
git pull origin master

# Copy files
echo "📋 Copying files..."
rsync -av --delete \
    --exclude='.git' \
    "$WIKI_SOURCE/" "$WIKI_REPO/"

# Commit and push
echo "🚀 Pushing to GitHub..."
git add .

if git diff --staged --quiet; then
    echo "✅ No changes to push"
else
    git commit -m "📚 Update wiki documentation - $(date '+%Y-%m-%d %H:%M')"
    git push origin master
    echo "✅ Wiki updated on GitHub!"
    echo "🌐 View: https://github.com/Raf7c/dotfiles/wiki"
fi
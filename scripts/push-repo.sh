#!/bin/bash
# Push your local repository to a remote Git repository
# Usage: ./push-repo.sh [repository_url]

set -e

# Default repository URL - Will prompt if not provided
DEFAULT_REPO_URL="https://github.com/username/repository.git"

# Get repository URL from command line argument or environment variable
REPO_URL="${1:-${GIT_REPO_URL:-}}"

# If no URL provided, prompt for one
if [ -z "$REPO_URL" ]; then
  read -p "Enter Git repository URL: " REPO_URL
  
  # If still empty, use default
  if [ -z "$REPO_URL" ]; then
    echo "⚠️  No repository URL provided, using default: $DEFAULT_REPO_URL"
    REPO_URL="$DEFAULT_REPO_URL"
  fi
fi

# Check if repository already has a remote origin
if git remote | grep -q "^origin$"; then
  echo "Remote 'origin' already exists."
  echo "Current URL: $(git remote get-url origin)"
  
  read -p "Do you want to update it to $REPO_URL? (y/n): " update_remote
  if [ "$update_remote" = "y" ]; then
    git remote set-url origin "$REPO_URL"
    echo "✅ Remote 'origin' updated to $REPO_URL"
  fi
else
  echo "Adding remote 'origin'..."
  git remote add origin "$REPO_URL"
  echo "✅ Remote 'origin' added: $REPO_URL"
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🚀 Pushing to remote repository..."
git push -u origin "$CURRENT_BRANCH"

echo "✅ Repository pushed successfully!"
echo "Your code is now available at: $REPO_URL"

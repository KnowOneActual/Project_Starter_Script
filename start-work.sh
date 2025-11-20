#!/bin/bash

# --- Git Workflow Starter ---
# 1. Checks for uncommitted changes.
# 2. Asks for a branch type and name.
# 3. Syncs the main branch (Auto-detected).
# 4. Creates and switches to the new branch.

# --- Step 0: Auto-detect Main Branch ---
# Attempts to find the default branch name (main, master, etc.)
MAIN_BRANCH=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5)

# Fallback if offline or detection fails
if [ -z "$MAIN_BRANCH" ]; then
    MAIN_BRANCH="main"
fi

echo "🔄 Target Main Branch: $MAIN_BRANCH"

# --- Step 1: Check for a clean working directory ---
echo "Checking workspace status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Your working directory is not clean."
    read -p "Would you like to stash these changes and continue? (y/n): " stash_choice
    if [[ "$stash_choice" =~ ^[Yy]$ ]]; then
        git stash push -m "Auto-stashed by start-work.sh"
        echo "📦 Changes stashed."
    else
        echo "❌ Please commit or stash your changes manually."
        exit 1
    fi
else
    echo "✅ Workspace is clean."
fi
echo ""

# --- Step 2: Get the new branch name ---
echo "Select the type of branch:"
echo "  1) feature/  (New features)"
echo "  2) bugfix/   (Bug fixes)"
echo "  3) hotfix/   (Urgent production fixes)"
echo "  4) custom    (No prefix)"
read -p "Choose (1-4): " type_choice

case $type_choice in
    1) prefix="feature/" ;;
    2) prefix="bugfix/" ;;
    3) prefix="hotfix/" ;;
    *) prefix="" ;;
esac

echo "Enter the name for your new branch (e.g., add-user-login):"
read -r RAW_NAME

if [ -z "$RAW_NAME" ]; then
    echo "❌ No branch name entered. Aborting."
    exit 1
fi

BRANCH_NAME="${prefix}${RAW_NAME}"
echo "Target Branch: $BRANCH_NAME"
echo ""

# --- Step 3: Syncing the main branch ---
echo "1. Switching to '$MAIN_BRANCH' branch..."
git checkout $MAIN_BRANCH

echo "2. Pulling the latest changes..."
git pull origin $MAIN_BRANCH

if [ $? -ne 0 ]; then
    echo "❌ 'git pull' failed. Please resolve issues first."
    exit 1
fi

# --- Step 4: Creating the new branch ---
echo "3. Creating and switching to: '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"

echo ""
echo "✅ You are now on branch '$BRANCH_NAME'."
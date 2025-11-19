#!/bin/bash

# --- Git Workflow Starter ---
# This script automates the process of starting a new task.
# 1. Checks for uncommitted changes (and offers to stash them).
# 2. Asks for a branch type and name.
# 3. Syncs the main branch.
# 4. Creates and switches to the new branch.

# Set the default main branch name.
MAIN_BRANCH="main"

# --- Step 1: Check for a clean working directory ---
echo "🔄 Preparing your workspace..."
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
    echo "✅ Your workspace is clean."
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

# Check if a branch name was provided.
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

echo "2. Pulling the latest changes from the remote..."
git pull origin $MAIN_BRANCH

# Check if the pull was successful
if [ $? -ne 0 ]; then
    echo "❌ 'git pull' failed. Please resolve the issues before creating a new branch."
    exit 1
fi

# --- Step 4: Creating the new branch ---
echo "3. Creating and switching to new branch: '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"

echo ""
echo "✅ Done! You are now on branch '$BRANCH_NAME' and ready to start working."
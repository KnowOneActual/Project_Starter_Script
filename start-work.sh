#!/bin/bash

# --- Git Workflow Starter ---
# 1. Checks for uncommitted changes.
# 2. Asks for (or accepts) a branch type and name.
# 3. Syncs the main branch (Auto-detected).
# 4. Creates and switches to the new branch.

# --- Argument Parsing ---
# Allow passing arguments directly: ./start-work.sh [type] [name]
ARG_TYPE=$1
ARG_NAME=$2

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
    # FIX: Loop to handle typos safely
    while true; do
        read -p "Would you like to stash these changes and continue? (y/n): " stash_choice
        case $stash_choice in
            [Yy]* )
                git stash push -m "Auto-stashed by start-work.sh"
                echo "📦 Changes stashed."
                break
                ;;
            [Nn]* )
                echo "❌ Please commit or stash your changes manually."
                exit 1
                ;;
            * ) echo "❌ Please answer 'y' or 'n'." ;;
        esac
    done
else
    echo "✅ Workspace is clean."
fi
echo ""

# --- Step 2: Get the new branch name ---

# Logic to handle Branch Type (Argument vs Menu)
if [ -n "$ARG_TYPE" ]; then
    # Map text arguments to numbers for the case statement
    case $ARG_TYPE in
        feature|feat) type_choice=1 ;;
        bugfix|fix|bug) type_choice=2 ;;
        hotfix) type_choice=3 ;;
        *) type_choice=4 ;; # Default to custom if unknown
    esac
    echo "🚀 Fast-track mode: creating '$ARG_TYPE' branch."
else
    echo "Select the type of branch:"
    echo "  1) feature/  (New features)"
    echo "  2) bugfix/   (Bug fixes)"
    echo "  3) hotfix/   (Urgent production fixes)"
    echo "  4) custom    (No prefix)"
    read -p "Choose (1-4): " type_choice
fi

case $type_choice in
    1) prefix="feature/" ;;
    2) prefix="bugfix/" ;;
    3) prefix="hotfix/" ;;
    *) prefix="" ;;
esac

# Logic to handle Branch Name (Argument vs Prompt)
if [ -n "$ARG_NAME" ]; then
    RAW_NAME="$ARG_NAME"
else
    echo "Enter the name for your new branch (e.g., add-user-login):"
    read -r RAW_NAME
fi

# Sanitize: lowercase and replace spaces with hyphens
CLEAN_NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

if [ -z "$CLEAN_NAME" ]; then
    echo "❌ No branch name entered. Aborting."
    exit 1
fi

BRANCH_NAME="${prefix}${CLEAN_NAME}"
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

# --- Step 4: Creating (or Switching to) the branch ---
echo "3. Preparing branch: '$BRANCH_NAME'..."

# Check if branch already exists locally
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "⚠️  Branch '$BRANCH_NAME' already exists locally."
    read -p "Switch to it instead? (y/n): " switch_choice
    if [[ "$switch_choice" =~ ^[Yy]$ ]]; then
        git checkout "$BRANCH_NAME"
        echo ""
        echo "✅ Switched to existing branch '$BRANCH_NAME'."
        exit 0
    else
        echo "❌ Aborting to prevent overwriting work."
        exit 1
    fi
fi

# Attempt to create the branch and capture the success/failure
if git checkout -b "$BRANCH_NAME"; then
    echo ""
    echo "✅ You are now on branch '$BRANCH_NAME'."
else
    echo ""
    echo "❌ Failed to create branch '$BRANCH_NAME'."
    echo "   (Please check for invalid characters or existing branches with similar names)"
    exit 1
fi
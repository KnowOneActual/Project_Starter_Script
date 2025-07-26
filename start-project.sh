#!/bin/bash

# A script to automate creating a new project, signing the first commit with GPG, and pushing it to GitHub.
# --- Functions ---

# Updated function to handle a custom HTML gitignore or fetch from the API.
create_gitignore() {
    local lang=$(echo "$1" | tr '[:upper:]' '[:lower:]') # Standardize to lowercase

    # Check for the user's special case: "html"
    if [ "$lang" == "html" ]; then
        echo "🔽 Using your custom HTML .gitignore boilerplate..."
        if curl -sL "https://raw.githubusercontent.com/KnowOneActual/start-work-script/refs/heads/main/.gitignore" -o ".gitignore"; then
            echo "✅ Custom .gitignore created successfully."
        else
            echo "⚠️  Warning: Could not fetch your custom .gitignore. A blank file was created."
            touch .gitignore
        fi
    # For all other languages, use the API
    else
        echo "Creating a .gitignore for $lang via API..."
        if curl -sL "https://www.toptal.com/developers/gitignore/api/$lang" -o ".gitignore"; then
            # Check if the API returned an error
            if grep -q "ERROR:" ".gitignore"; then
                 echo "⚠️  Warning: The API does not have a template for '$lang'. A blank file was created."
                 # Clear the file of the error message
                 > .gitignore
            else
                 echo "✅ .gitignore created successfully."
            fi
        else
            echo "⚠️  Warning: Could not fetch .gitignore from API. A blank file was created."
            touch .gitignore
        fi
    fi
}

# --- Main Script ---

# Ask for the project name
read -p "Enter your project name: " project_name

# Create the main project directory and navigate into it
mkdir "$project_name"
cd "$project_name"

echo "--------------------------------------------------"
echo "🚀 Creating project: $project_name"
echo "--------------------------------------------------"

# --- Git Initialization ---
echo "🌿 Initializing Git repository with 'main' branch..."
git init -b main

# --- Directory and File Creation ---
echo "📂 Creating core directories and files..."
mkdir src
touch src/main # Placeholder, will be renamed later
echo "# $project_name" > README.md
# (Assuming LICENSE and .editorconfig creation logic is here)

# --- Download Supporting Scripts ---
echo "🔽 Downloading start-work.sh script..."
curl -o start-work.sh https://raw.githubusercontent.com/KnowOneActual/start-work-script/refs/heads/main/start-work.sh
chmod +x start-work.sh
echo "✅ start-work.sh is ready to use."

# --- Optional Directories ---
read -p "Add a 'docs' directory? (y/n): " add_docs
if [[ "$add_docs" =~ ^[Yy]$ ]]; then
    mkdir docs
    touch docs/index.md
fi

read -p "Add a 'tests' directory? (y/n): " add_tests
if [[ "$add_tests" =~ ^[Yy]$ ]]; then
    mkdir tests
fi

# --- Language-Specific Setup ---
read -p "Enter the primary language (e.g., python, node, go, html): " language
create_gitignore "$language"

# Rename main file and perform language-specific tasks
# (Assuming language-specific logic is here)

# --- GPG Signing Setup ---
commit_flags="-m 'Initial commit: project structure setup'"
read -p "Sign this commit with a GPG key? (y/n): " use_gpg
if [[ "$use_gpg" =~ ^[Yy]$ ]]; then
    signing_key=$(git config user.signingkey)
    if [ -z "$signing_key" ]; then
        echo "No default GPG key found in your Git config."
        echo "Available GPG keys:"
        gpg --list-secret-keys --keyid-format LONG
        read -p "Please enter the GPG key ID you want to use: " gpg_key_id
        git config user.signingkey "$gpg_key_id"
    fi
    commit_flags="-S $commit_flags"
    echo "✅ Commits will be signed."
fi

# --- Final Local Git Commit ---
echo "💾 Saving initial project state..."
git add .
eval "git commit $commit_flags"

echo "--------------------------------------------------"
echo "✅ Local project '$project_name' is ready!"
echo "--------------------------------------------------"

# --- GitHub Push Guide ---
read -p "Would you like to push this project to GitHub now? (y/n): " push_to_github
if [[ "$push_to_github" =~ ^[Yy]$ ]]; then
    if command -v gh &> /dev/null; then
        echo "GitHub CLI detected."
        read -p "Create a new public repository named '$project_name'? (y/n): " create_repo
        if [[ "$create_repo" =~ ^[Yy]$ ]]; then
            gh repo create "$project_name" --public --source=. --push
            echo "🎉 All done! Your project is now on GitHub."
        fi
    else
        echo "GitHub CLI not found. Continuing with manual setup."
        echo ""
        echo "Please go to https://github.com/new and create a new repository."
        read -p "Once you have the repository URL, paste it here: " repo_url
        if [ -n "$repo_url" ]; then
            git remote add origin "$repo_url"
            git push -u origin main
            echo "🎉 All done! Your project is now on GitHub."
        fi
    fi
fi

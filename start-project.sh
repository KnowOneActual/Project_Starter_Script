#!/bin/bash

# =================================================================================
# Project Starter Script 🚀
# Automates the setup of new software projects, including directory structure,
# boilerplate files, Git initialization, and pushing to GitHub.
# =================================================================================

# --- Safeguard ---
# Prevent the script from running in the home directory.
if [ "$PWD" == "$HOME" ]; then
    echo "❌ Error: Running this script in the home directory is not allowed."
    echo "Please run it from a dedicated projects or development directory."
    exit 1
fi


# --- Functions ---

create_gitignore() {
    echo "--------------------------------------------------"
    echo "Select a .gitignore option:"
    echo "  1) Use my standard boilerplate (from gitignore-boilerplate repo)"
    echo "  2) Fetch a language-specific .gitignore from an API"
    read -p "Enter your choice (1 or 2): " gitignore_choice

    if [ "$gitignore_choice" == "1" ]; then
        echo "🔽 Downloading your standard .gitignore boilerplate..."
        if curl -sL "https://raw.githubusercontent.com/KnowOneActual/gitignore-boilerplate/main/.gitignore" -o ".gitignore"; then
            echo "✅ Custom .gitignore created successfully."
        else
            echo "⚠️  Warning: Could not fetch your custom .gitignore. A blank file was created."
            touch .gitignore
        fi
    else
        read -p "Enter the primary language for the .gitignore API (e.g., python, node, go): " lang
        echo "Creating a .gitignore for $lang via API..."
        if curl -sL "https://www.toptal.com/developers/gitignore/api/$lang" -o ".gitignore"; then
            if grep -q "ERROR:" ".gitignore"; then
                 echo "⚠️  Warning: The API does not have a template for '$lang'. A blank file was created."
                 > .gitignore
            else
                 echo "✅ .gitignore for $lang created successfully."
            fi
        else
            echo "⚠️  Warning: Could not fetch .gitignore from API. A blank file was created."
            touch .gitignore
        fi
    fi
}


# --- Main Script ---

clear
echo "=================================================="
echo "🚀 Welcome to the Project Starter Script"
echo "=================================================="

# 1. Get Project Name
read -p "Enter your project name: " project_name

# 2. Create Project Directory
mkdir "$project_name"
cd "$project_name"

echo "--------------------------------------------------"
echo "🚀 Creating project: $project_name"
echo "--------------------------------------------------"

# 3. Initialize Git
echo "🌿 Initializing Git repository with 'main' branch..."
git init -b main

# 4. Create Core Directories
echo "📂 Creating core directories (src, docs, tests)..."
mkdir src docs tests
touch src/main # Placeholder file
touch docs/index.md

# 5. Download Standard Boilerplate Files
echo "🔽 Downloading standard boilerplate files..."
curl -sL "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/.editorconfig" -o ".editorconfig"
curl -sL "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/CONTRIBUTING.md" -o "CONTRIBUTING.md"
curl -sL "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/CHANGELOG.md" -o "CHANGELOG.md"

# 6. Create README and LICENSE
echo "# $project_name" > README.md
echo "MIT License - see the LICENSE file for details." >> README.md
# A simple MIT License file
{
    echo "MIT License"
    echo ""
    echo "Copyright (c) $(date +%Y) $(git config user.name)"
    echo ""
    echo "Permission is hereby granted, free of charge, to any person obtaining a copy"
    echo "of this software and associated documentation files (the \"Software\"), to deal"
    echo "in the Software without restriction, including without limitation the rights"
    echo "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell"
    echo "copies of the Software, and to permit persons to whom the Software is"
    echo "furnished to do so, subject to the following conditions:"
    echo ""
    echo "The above copyright notice and this permission notice shall be included in all"
    echo "copies or substantial portions of the Software."
    echo ""
    echo "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR"
    echo "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,"
    echo "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE"
    echo "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER"
    echo "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,"
    echo "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE"
    echo "SOFTWARE."
} > LICENSE

# 7. Download GitHub Issue Templates
echo "🔽 Creating GitHub issue templates..."
mkdir -p .github/ISSUE_TEMPLATE
# You will need to create these files in your Project_Starter_Script repository first
curl -sL "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/.github/ISSUE_TEMPLATE/bug_report.md" -o ".github/ISSUE_TEMPLATE/bug_report.md"
curl -sL "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/.github/ISSUE_TEMPLATE/feature_request.md" -o ".github/ISSUE_TEMPLATE/feature_request.md"

# 8. Download Supporting Scripts
echo "🔽 Downloading supporting scripts (start-work.sh)..."
curl -sL -o start-work.sh https://raw.githubusercontent.com/KnowOneActual/start-work-script/main/start-work.sh
chmod +x start-work.sh
echo "✅ Standard files and scripts are ready."

# 9. Get .gitignore
create_gitignore

# (Placeholder for additional language-specific logic, like creating a Python venv)

# 10. GPG Signing
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

# 11. Final Local Commit
echo "💾 Saving initial project state..."
git add .
eval "git commit $commit_flags"

echo "--------------------------------------------------"
echo "✅ Local project '$project_name' is ready!"
echo "--------------------------------------------------"

# 12. GitHub Push Guide
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

echo "=================================================="
echo "Happy coding!"
echo "=================================================="
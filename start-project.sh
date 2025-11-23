#!/bin/bash

# =================================================================================
# Project Starter Script 🚀
# Automates the setup of new software projects, including directory structure,
# boilerplate files, Git initialization, environment setup, and GitHub pushing.
# =================================================================================

# --- Pre-flight Checks ---
# Ensure necessary tools are installed before doing anything.
missing_tools=()
command -v git >/dev/null 2>&1 || missing_tools+=("git")
command -v curl >/dev/null 2>&1 || missing_tools+=("curl")

if [ ${#missing_tools[@]} -ne 0 ]; then
    echo "❌ Error: Missing required tools: ${missing_tools[*]}"
    echo "Please install them and try again."
    exit 1
fi

# --- Safeguard ---
# Prevent the script from running in the home directory.
if [ "$PWD" == "$HOME" ]; then
    echo "❌ Error: Running this script in the home directory is not allowed."
    echo "Please run it from a dedicated projects or development directory."
    exit 1
fi

# --- Functions ---

download_file() {
    local url=$1
    local output=$2
    echo "   Downloading $output..."
    curl -sL "$url" -o "$output"
}

setup_language_env() {
    local lang=$1
    
    # Normalize input to lowercase
    lang=$(echo "$lang" | tr '[:upper:]' '[:lower:]')

    if [[ "$lang" == "python" ]]; then
        echo "--------------------------------------------------"
        echo "🐍 Python detected. Setting up virtual environment..."
        python3 -m venv .venv
        # Upgrade pip inside the venv
        ./.venv/bin/pip install --upgrade pip
        touch requirements.txt
        # Ensure venv is ignored
        if ! grep -q ".venv/" .gitignore; then
            echo ".venv/" >> .gitignore
        fi
        echo "✅ Virtual environment created in .venv/"

    elif [[ "$lang" == "node" || "$lang" == "javascript" || "$lang" == "typescript" ]]; then
        echo "--------------------------------------------------"
        echo "📦 Node.js detected. Initializing project..."
        npm init -y
        # Create .nvmrc with current node version
        node -v > .nvmrc
        echo "✅ package.json and .nvmrc created."
    fi
}

create_gitignore_and_env() {
    echo "--------------------------------------------------"
    echo "Select a .gitignore option:"
    echo "  1) Use my standard boilerplate (from gitignore-boilerplate repo)"
    echo "  2) Fetch a language-specific .gitignore from an API"
    read -p "Enter your choice (1 or 2): " gitignore_choice

    if [ "$gitignore_choice" == "1" ]; then
        echo "🔽 Downloading your standard .gitignore boilerplate..."
        if download_file "https://raw.githubusercontent.com/KnowOneActual/gitignore-boilerplate/main/.gitignore" ".gitignore"; then
            echo "✅ Custom .gitignore created successfully."
        else
            echo "⚠️  Warning: Could not fetch your custom .gitignore. A blank file was created."
            touch .gitignore
        fi
    else
        read -p "Enter the primary language (e.g., python, node, go): " lang
        echo "Creating a .gitignore for $lang via API..."
        if download_file "https://www.toptal.com/developers/gitignore/api/$lang" ".gitignore"; then
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
        
        # Run the environment setup based on the language chosen
        setup_language_env "$lang"
    fi
}

# --- Main Script ---

clear
echo "=================================================="
echo "🚀 Welcome to the Project Starter Script"
echo "=================================================="

# 1. Get Project Name
if [ -n "$1" ]; then
    project_name="$1"
    echo "Targeting project: $project_name"
else
    read -p "Enter your project name: " project_name
fi

# Validate input
if [[ "$project_name" =~ [[:space:]] ]]; then
    echo "❌ Error: Project names cannot contain spaces. Use hyphens or underscores."
    exit 1
fi

# 2. Create Project Directory
if [ -d "$project_name" ]; then
    echo "❌ Error: Directory '$project_name' already exists."
    read -p "Do you want to overwrite it? (DANGEROUS - existing files may be lost) (y/n): " confirm_overwrite
    if [[ "$confirm_overwrite" != "y" ]]; then
        echo "Aborting."
        exit 1
    fi
else
    mkdir "$project_name"
fi

cd "$project_name" || exit

echo "--------------------------------------------------"
echo "🚀 Creating project: $project_name"
echo "--------------------------------------------------"

# 3. Initialize Git
echo "🌿 Initializing Git repository..."
if git init -b main >/dev/null 2>&1; then
    echo "   Initialized with branch 'main'."
else
    git init
    git checkout -b main 2>/dev/null || git symbolic-ref HEAD refs/heads/main
    echo "   Initialized (legacy mode)."
fi

# 4. Create Core Directories
echo "📂 Creating core directories..."
mkdir src docs tests
touch src/main
touch docs/index.md

# 5. Download Boilerplate Files
echo "🔽 Downloading boilerplate files..."
BASE_URL="https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main"
TEMPLATE_URL="$BASE_URL/templates"

# Configs (from root)
download_file "$BASE_URL/.editorconfig" ".editorconfig"
download_file "$BASE_URL/.prettierrc" ".prettierrc"
download_file "$BASE_URL/.prettierignore" ".prettierignore"

# Documentation (from templates)
download_file "$TEMPLATE_URL/CONTRIBUTING.md" "CONTRIBUTING.md"
download_file "$TEMPLATE_URL/CHANGELOG.md" "CHANGELOG.md"

# 6. Create README and LICENSE
echo "# $project_name" > README.md
echo "MIT License - see the LICENSE file for details." >> README.md

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

# 7. GitHub Templates & CI/CD
echo "🔽 Creating GitHub templates and workflows..."
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/workflows

download_file "$BASE_URL/.github/ISSUE_TEMPLATE/bug_report.md" ".github/ISSUE_TEMPLATE/bug_report.md"
download_file "$BASE_URL/.github/ISSUE_TEMPLATE/feature_request.md" ".github/ISSUE_TEMPLATE/feature_request.md"
download_file "$BASE_URL/.github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md"
# Download the CI workflow (You must create this file in your repo first!)
download_file "$TEMPLATE_URL/ci.yml" ".github/workflows/ci.yml"

# 8. Download Supporting Scripts
echo "🔽 Downloading start-work.sh..."
# Note: Ensure you update the start-work-script repo with the new auto-detect logic
download_file "https://raw.githubusercontent.com/KnowOneActual/start-work-script/main/start-work.sh" "start-work.sh"
chmod +x start-work.sh

echo "✅ Standard files and scripts are ready."

# 9. Get .gitignore & Setup Env
create_gitignore_and_env

# 10. GPG Signing
commit_flags="-m 'Initial commit: project structure setup'"
read -p "Sign this commit with a GPG key? (y/n): " use_gpg
if [[ "$use_gpg" =~ ^[Yy]$ ]]; then
    signing_key=$(git config user.signingkey)
    if [ -z "$signing_key" ]; then
        echo "No default GPG key found in your Git config."
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
while true; do
    read -p "Would you like to push this project to GitHub now? (y/n): " push_to_github
    case $push_to_github in
        [Yy]* ) 
            if command -v gh &> /dev/null; then
                echo "GitHub CLI detected."
                # Nested loop for the second prompt to be safe
                while true; do
                    read -p "Create a new public repository named '$project_name'? (y/n): " create_repo
                    case $create_repo in
                        [Yy]* )
                            gh repo create "$project_name" --public --source=. --push
                            echo "🎉 All done! Your project is now on GitHub."
                            break
                            ;;
                        [Nn]* )
                            echo "Skipping repo creation."
                            break
                            ;;
                        * ) echo "❌ Please answer 'y' or 'n'." ;;
                    esac
                done
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
            break 
            ;;
        [Nn]* ) 
            echo "Skipping GitHub setup."
            break 
            ;;
        * ) 
            echo "❌ Invalid input. Please answer 'y' or 'n'." 
            ;;
    esac
done

echo "=================================================="
echo "Happy coding!"
echo "=================================================="
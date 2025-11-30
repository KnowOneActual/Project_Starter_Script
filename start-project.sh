#!/bin/bash
set -euo pipefail

# =================================================================================
# Project Starter Script 🚀
# =================================================================================

# Colors (use $'' so \033 works correctly)
if [[ -t 1 ]]; then
    RED=$'\033[0;31m'
    GREEN=$'\033[0;32m'
    YELLOW=$'\033[1;33m'
    BLUE=$'\033[0;34m'
    PURPLE=$'\033[0;35m'
    NC=$'\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    PURPLE=''
    NC=''
fi

# Globals
DRY_RUN=false
PROJECT_NAME=""
BASE_URL="https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main"
TEMPLATE_URL="${BASE_URL}/templates"

spinner() {
    local pid="$1"
    local spinstr='⠏⠇⠧⠦⠴⠼⠸⠹'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(((i + 1) % 8))
        # 2 %s → 2 args → ShellCheck OK
        printf '\r%s %s ' "${spinstr:i:1}" "${PURPLE}Waiting...${NC}"
        sleep 0.1
    done
    # Clear line
    printf '\r\033[K'
}

download_file() {
    local url="$1"
    local output="$2"
    local dry_run="${3:-false}"

    if [[ "$dry_run" == "true" ]]; then
        printf '   %s[DRY-RUN]%s Would download %s from %s\n' "$YELLOW" "$NC" "$output" "$url"
        return 0
    fi

    printf '   %s⬇️ %s Downloading %s...\n' "$BLUE" "$NC" "$output"

    if command -v curl >/dev/null 2>&1; then
        local temp_file
        temp_file="$(mktemp)"
        curl -sLf --progress-bar "$url" -o "$temp_file" &
        spinner "$!"
        if [[ -s "$temp_file" ]]; then
            mv "$temp_file" "$output"
            printf '   %s✅%s %s downloaded successfully\n' "$GREEN" "$NC" "$output"
        else
            rm -f "$temp_file"
            printf '   %s❌%s Failed to download %s\n' "$RED" "$NC" "$output"
            return 1
        fi
    else
        if ! curl -sLf "$url" -o "$output"; then
            printf '   %s❌%s Failed to download %s\n' "$RED" "$NC" "$output"
            return 1
        fi
        printf '   %s✅%s %s downloaded successfully\n' "$GREEN" "$NC" "$output"
    fi
}

check_dependencies() {
    local -a missing=()
    command -v git >/dev/null 2>&1 || missing+=("git")
    command -v curl >/dev/null 2>&1 || missing+=("curl")

    if [[ ${#missing[@]} -ne 0 ]]; then
        printf '%s❌ Missing dependencies:%s %s\n' "$RED" "$NC" "${missing[*]}"
        printf 'Install with:\n'
        printf '  macOS: brew install %s\n' "${missing[@]}"
        printf '  Linux: sudo apt install %s\n' "${missing[@]}"
        exit 1
    fi

    printf '%s✅ All dependencies present%s\n' "$GREEN" "$NC"
}

usage() {
    printf 'Usage: %s [-d|--dry-run] [project_name]\n' "$0"
    printf '  -d, --dry-run  Preview actions without executing\n'
    exit 1
}

# --- Parse CLI args ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$PROJECT_NAME" ]]; then
                PROJECT_NAME="$1"
            else
                printf '%s❌ Too many arguments.%s\n' "$RED" "$NC"
                usage
            fi
            shift
            ;;
    esac
done

if [[ -z "$PROJECT_NAME" ]]; then
    read -rp "Enter project name: " PROJECT_NAME
fi

if [[ -z "$PROJECT_NAME" ]]; then
    printf '%s❌ Project name cannot be empty.%s\n' "$RED" "$NC"
    exit 1
fi

check_dependencies

printf '%s🚀 Starting new project:%s %s\n' "$BLUE" "$NC" "$PROJECT_NAME"

if [[ "$DRY_RUN" == "true" ]]; then
    printf '%s[DRY-RUN]%s No files will be written.\n' "$YELLOW" "$NC"
fi

# Create project directory and basic structure
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

printf '%s📁 Creating basic structure...%s\n' "$BLUE" "$NC"
if [[ "$DRY_RUN" != "true" ]]; then
    mkdir -p src tests docs .github
fi

# Base templates
printf '%s📄 Fetching base templates...%s\n' "$BLUE" "$NC"
download_file "${TEMPLATE_URL}/README.md" "README.md" "$DRY_RUN"
download_file "${TEMPLATE_URL}/CHANGELOG.md" "CHANGELOG.md" "$DRY_RUN"
download_file "${TEMPLATE_URL}/CONTRIBUTING.md" "CONTRIBUTING.md" "$DRY_RUN"

# LICENSE
if [[ "$DRY_RUN" != "true" ]]; then
    cat > LICENSE <<'EOF'
MIT License

Copyright (c)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is   
furnished to do so, subject to the following conditions:

[Replace this with your full MIT License text]
EOF
    printf '%s✅ LICENSE created%s\n' "$GREEN" "$NC"
else
    printf '   %s[DRY-RUN]%s Would create LICENSE file\n' "$YELLOW" "$NC"
fi

# Git init
printf '%s🔧 Initializing git...%s\n' "$BLUE" "$NC"
if [[ "$DRY_RUN" != "true" ]]; then
    git init -b main >/dev/null 2>&1 || git init >/dev/null 2>&1
    git config init.defaultBranch main || true
else
    printf '   %s[DRY-RUN]%s Would run git init\n' "$YELLOW" "$NC"
fi

# GitHub templates
printf '%s📂 Setting up GitHub templates...%s\n' "$BLUE" "$NC"
if [[ "$DRY_RUN" != "true" ]]; then
    mkdir -p .github/ISSUE_TEMPLATE .github/workflows
fi
download_file "${BASE_URL}/.github/ISSUE_TEMPLATE/bug_report.md" ".github/ISSUE_TEMPLATE/bug_report.md" "$DRY_RUN"
download_file "${BASE_URL}/.github/ISSUE_TEMPLATE/feature_request.md" ".github/ISSUE_TEMPLATE/feature_request.md" "$DRY_RUN"
download_file "${BASE_URL}/.github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md" "$DRY_RUN"

# Download companion script
printf '%s🔧 Fetching start-work.sh helper...%s\n' "$BLUE" "$NC"
download_file "${BASE_URL}/start-work.sh" "start-work.sh" "$DRY_RUN"
if [[ "$DRY_RUN" != "true" ]]; then
    chmod +x start-work.sh
fi

# .gitignore
printf '\n%s📋 Creating .gitignore...%s\n' "$BLUE" "$NC"
read -rp "Use language-specific (python/node/go) or boilerplate template? (l/b): " gitignore_choice

if [[ "$gitignore_choice" == "l" ]]; then
    read -rp "Primary language: " lang
    download_file "https://www.toptal.com/developers/gitignore/api/${lang}" ".gitignore" "$DRY_RUN"

    case "$lang" in
        python)
            if [[ "$DRY_RUN" != "true" ]]; then
                python3 -m venv .venv || python -m venv .venv || true
                touch requirements.txt
            else
                printf '   %s[DRY-RUN]%s Would create Python venv and requirements.txt\n' "$YELLOW" "$NC"
            fi
            ;;
        node|javascript|typescript)
            if [[ "$DRY_RUN" != "true" ]]; then
                npm init -y || true
                node --version > .nvmrc || true
            else
                printf '   %s[DRY-RUN]%s Would run npm init and set .nvmrc\n' "$YELLOW" "$NC"
            fi
            ;;
        go)
            if [[ "$DRY_RUN" != "true" ]]; then
                go mod init "$PROJECT_NAME" || true
            else
                printf '   %s[DRY-RUN]%s Would run go mod init\n' "$YELLOW" "$NC"
            fi
            ;;
        *)
            printf '%sℹ️ No extra language setup for "%s"%s\n' "$YELLOW" "$lang" "$NC"
            ;;
    esac
elif [[ "$gitignore_choice" == "b" ]]; then
    download_file "${BASE_URL}/.gitignore" ".gitignore" "$DRY_RUN"
else
    printf '%sℹ️ Unknown choice, using boilerplate .gitignore.%s\n' "$YELLOW" "$NC"
    download_file "${BASE_URL}/.gitignore" ".gitignore" "$DRY_RUN"
fi

# Final commit
if [[ "$DRY_RUN" != "true" ]]; then
    git add .
    read -rp "Sign commit with GPG? (y/n): " gpg_choice
    if [[ "$gpg_choice" == "y" ]]; then
        git commit -S -m "Initial commit: ${PROJECT_NAME} setup"
    else
        git commit -m "Initial commit: ${PROJECT_NAME} setup"
    fi
else
    printf '   %s[DRY-RUN]%s Would add files and create initial git commit\n' "$YELLOW" "$NC"
fi

printf '\n%s🎉 Project %s ready!%s\n' "$GREEN" "$PROJECT_NAME" "$NC"

read -rp "Push to GitHub now? (y/n): " push_choice
if [[ "$push_choice" == "y" ]]; then
    if command -v gh >/dev/null 2>&1; then
        if [[ "$DRY_RUN" != "true" ]]; then
            gh repo create "$PROJECT_NAME" --public --source=. --push
            printf '%s🎉 Live on GitHub!%s\n' "$GREEN" "$NC"
        else
            printf '   %s[DRY-RUN]%s Would run gh repo create ... --push\n' "$YELLOW" "$NC"
        fi
    else
        printf '%s⚠️ gh CLI not installed; skipping auto GitHub push.%s\n' "$YELLOW" "$NC"
    fi
fi

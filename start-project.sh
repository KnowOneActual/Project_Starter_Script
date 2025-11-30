#!/bin/bash

set -euo pipefail

# =================================================================================
# Project Starter Script 🚀 (Enhanced v2.0)
# Fixed ShellCheck issues, integrated full functionality
# =================================================================================

# Colors for better UX
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Global variables
DRY_RUN=false
PROJECT_NAME=""
BASE_URL="https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main"
TEMPLATE_URL="${BASE_URL}/templates"

spinner() {
    local pid="${1}"
    local spinstr='⠏⠇⠧⠦⠴⠼⠸⠹'
    local i=0
    while kill -0 "${pid}" 2>/dev/null; do
        i=$(((i + 1) % 8))
        printf '\r%s %s%s%s ' "${spinstr:${i}:1}" "${BLUE}[PROCESSING]${NC}"
        sleep 0.1
    done
    printf '\r\033[K'
}

# Enhanced download with progress and validation
download_file() {
    local url="${1}"
    local output="${2}"
    local dry_run="${3:-false}"
    
    if [[ "${dry_run}" == "true" ]]; then
        printf '   %s[DRY-RUN]%s Would download %s from %s\n' "${YELLOW}" "${NC}" "${output}" "${url}"
        return 0
    fi
    
    printf '   %s⬇️ %s Downloading %s...\n' "${BLUE}" "${NC}" "${output}"
    
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        local temp_file
        temp_file=$(mktemp)
        curl -sLf --progress-bar "${url}" -o "${temp_file}" &
        spinner "${!}"
        if [[ -s "${temp_file}" ]]; then
            mv "${temp_file}" "${output}"
            printf '   %s✅%s %s downloaded successfully\n' "${GREEN}" "${NC}" "${output}"
        else
            rm -f "${temp_file}"
            printf '   %s❌%s Failed to download %s\n' "${RED}" "${NC}" "${output}"
            return 1
        fi
    else
        if ! curl -sLf "${url}" -o "${output}"; then
            printf '   %s❌%s Failed to download %s\n' "${RED}" "${NC}" "${output}"
            return 1
        fi
        printf '   %s✅%s %s downloaded successfully\n' "${GREEN}" "${NC}" "${output}"
    fi
}

check_dependencies() {
    local -a missing=()
    command -v git >/dev/null 2>&1 || missing+=("git")
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v jq >/dev/null 2>&1 || missing+=("jq")
    
    if [[ ${#missing[@]} -ne 0 ]]; then
        printf '%s❌ Missing dependencies:%s %s\n' "${RED}" "${NC}" "${missing[*]}"
        printf 'Install with: brew install %s (macOS) or apt install %s (Linux)\n' "${missing[*]}" "${missing[*]}"
        exit 1
    fi
    printf '%s✅ All dependencies present%s\n' "${GREEN}" "${NC}"
}

usage() {
    printf 'Usage: %s [-d|--dry-run] [project_name]\n' "${0}"
    printf '  -d, --dry-run  Preview actions without executing\n'
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case ${1} in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -*)
            printf 'Unknown option: %s\n' "${1}"
            usage
            ;;
        *)
            PROJECT_NAME="${1}"
            shift
            ;;
    esac
done

if [[ "${DRY_RUN}" == "true" ]]; then
    printf '%s🐌 Dry-run mode enabled%s\n' "${YELLOW}" "${NC}"
fi

check_dependencies

# Main execution starts here
if [[ -z "${PROJECT_NAME}" ]]; then
    read -rp "Enter your project name: " PROJECT_NAME
fi

# Sanitize project name
if [[ "${PROJECT_NAME}" =~ [[:space:]] ]]; then
    printf '%s⚠️  Project name contains spaces, auto-correcting...%s\n' "${YELLOW}" "${NC}"
    PROJECT_NAME="${PROJECT_NAME// /-}"
    printf '   New name: %s\n' "${PROJECT_NAME}"
fi

if [[ -d "${PROJECT_NAME}" ]]; then
    printf '%s❌ Directory %s already exists%s\n' "${RED}" "${PROJECT_NAME}" "${NC}"
    read -rp "Overwrite? (DANGEROUS) (y/n): " confirm
    [[ "${confirm}" != "y" ]] && exit 1
    rm -rf "${PROJECT_NAME}"
fi

mkdir -p "${PROJECT_NAME}" && cd "${PROJECT_NAME}" || exit 1

printf '\n%s🚀 Creating project: %s%s\n' "${GREEN}" "${PROJECT_NAME}" "${NC}"

# Initialize Git
git init -b main

# Create directories
mkdir -p src docs tests

# Download boilerplate files
download_file "${BASE_URL}/.editorconfig" ".editorconfig" "${DRY_RUN}"
download_file "${BASE_URL}/.prettierrc" ".prettierrc" "${DRY_RUN}"
download_file "${BASE_URL}/.prettierignore" ".prettierignore" "${DRY_RUN}"

download_file "${TEMPLATE_URL}/README.md" "README.md" "${DRY_RUN}" && \
sed -i.bak "s/# Project Name/# ${PROJECT_NAME}/" README.md && rm README.md.bak

download_file "${TEMPLATE_URL}/CONTRIBUTING.md" "CONTRIBUTING.md" "${DRY_RUN}"
download_file "${TEMPLATE_URL}/CHANGELOG.md" "CHANGELOG.md" "${DRY_RUN}"

# Create LICENSE
cat > LICENSE << 'EOF'
MIT License

Copyright (c) $(date +%Y) $(git config user.name)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# GitHub templates
mkdir -p .github/{ISSUE_TEMPLATE,workflows,PULL_REQUEST_TEMPLATE}
download_file "${BASE_URL}/.github/ISSUE_TEMPLATE/bug_report.md" ".github/ISSUE_TEMPLATE/bug_report.md" "${DRY_RUN}"
download_file "${BASE_URL}/.github/ISSUE_TEMPLATE/feature_request.md" ".github/ISSUE_TEMPLATE/feature_request.md" "${DRY_RUN}"
download_file "${BASE_URL}/.github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md" "${DRY_RUN}"

# Download companion script
download_file "https://raw.githubusercontent.com/KnowOneActual/Project_Starter_Script/main/start-work.sh" "start-work.sh" "${DRY_RUN}" && chmod +x start-work.sh

# Create .gitignore interactively
printf '\n%s📋 Creating .gitignore...%s\n' "${BLUE}" "${NC}"
read -rp "Use language-specific (python/node/go) or custom? (l/c): " gitignore_choice

if [[ "${gitignore_choice}" == "l" ]]; then
    read -rp "Primary language: " lang
    download_file "https://www.toptal.com/developers/gitignore/api/${lang}" ".gitignore" "${DRY_RUN}"
    
    # Language-specific setup
    case "${lang}" in
        python)
            python3 -m venv .venv
            ./.venv/bin/pip install --upgrade pip
            touch requirements.txt
            ;;
        node|javascript|typescript)
            npm init -y
            node --version > .nvmrc
            ;;
    esac
else
    download_file "${BASE_URL}/.gitignore" ".gitignore" "${DRY_RUN}"
fi

# Final commit
git add .
read -rp "Sign commit with GPG? (y/n): " gpg_choice
if [[ "${gpg_choice}" == "y" ]]; then
    git commit -S -m "Initial commit: ${PROJECT_NAME} setup"
else
    git commit -m "Initial commit: ${PROJECT_NAME} setup"
fi

printf '\n%s🎉 Project %s ready!%s\n' "${GREEN}" "${PROJECT_NAME}" "${NC}"

read -rp "Push to GitHub now? (y/n): " push_choice
if [[ "${push_choice}" == "y" ]] && command -v gh >/dev/null 2>&1; then
    gh repo create "${PROJECT_NAME}" --public --source=. --push
    printf '%s🎉 Live on GitHub!%s\n' "${GREEN}" "${NC}"
fi
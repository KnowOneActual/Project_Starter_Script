#!/bin/bash

set -euo pipefail

# =================================================================================
# Enhanced Git Workflow Starter (start-work.sh) 🚀
# Features: Logging, interactive prompts, dependency checks, timestamps
# =================================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Logging setup
LOG_FILE="work-session-$(date +%Y%m%d-%H%M%S).log"
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}
log_info() {
    log "${BLUE}INFO${NC}: $1"
}
log_success() {
    log "${GREEN}SUCCESS${NC}: $1"
}
log_warn() {
    log "${YELLOW}WARN${NC}: $1"
}
log_error() {
    log "${RED}ERROR${NC}: $1"
    exit 1
}

check_dependencies() {
    local missing=()
    command -v git >/dev/null 2>&1 || missing+=("git")
    
    if [[ ${#missing[@]} -ne 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}. Please install them first."
    fi
    log_info "Dependencies OK"
}

spinner() {
    local pid=$1
    local spinstr='⠏⠇⠧⠦⠴⠼⠸⠹'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        local i=$(((i+1)%8))
        printf "\r${PURPLE}%s${NC} " "${spinstr:$i:1} Waiting..."
        sleep 0.1
    done
    printf "\r\033[K"
}

# Auto-detect main branch with fallback
get_main_branch() {
    if git remote show origin >/dev/null 2>&1; then
        git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main"
    else
        echo "main"
    fi
}

# Interactive branch type selection with search
select_branch_type() {
    local arg_type=$1
    if [[ -n $arg_type ]]; then
        case $arg_type in
            feature|feat) echo "feature/" ;;
            bugfix|fix|bug) echo "bugfix/" ;;
            hotfix) echo "hotfix/" ;;
            *) echo "" ;;
        esac
        return
    fi
    
    echo "${BLUE}Select branch type:${NC}"
    PS3="Choose (1-5): "
    select type in "feature/" "bugfix/" "hotfix/" "release/" "Custom (no prefix)"; do
        [[ -n $type ]] && echo "$type" && break
        echo "Invalid selection"
    done
}

# Argument parsing
ARG_TYPE=${1:-}
ARG_NAME=${2:-}

log_info "Starting work session (log: $LOG_FILE)"
check_dependencies

MAIN_BRANCH=$(get_main_branch)
log_info "Target main branch: $MAIN_BRANCH"

# Check workspace
if git status --porcelain | grep -q .; then
    log_warn "Uncommitted changes detected"
    echo -n "${YELLOW}Stash and continue? (y/n): ${NC}"
    read -r choice
    if [[ $choice =~ ^[Yy] ]]; then
        git stash push -m "Auto-stash by start-work.sh" &
        spinner $!
        log_success "Changes stashed"
    else
        log_error "Please commit/stash manually"
    fi
fi

# Branch selection
PREFIX=$(select_branch_type "$ARG_TYPE")

if [[ -n $ARG_NAME ]]; then
    RAW_NAME="$ARG_NAME"
else
    echo -n "${BLUE}Branch name: ${NC}"
    read -r RAW_NAME
fi

CLEAN_NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr -s '[:space:]' '-' | sed 's/[^a-z0-9-]//g')
BRANCH_NAME="${PREFIX}${CLEAN_NAME}"

log_info "Creating/switching to: $BRANCH_NAME"

# Sync main
log_info "Syncing $MAIN_BRANCH"
git checkout "$MAIN_BRANCH" &
spinner $!
git pull origin "$MAIN_BRANCH" &
spinner $!

# Create/switch branch
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    log_warn "Branch exists locally"
    echo -n "${YELLOW}Switch to it? (y/n): ${NC}"
    read -r switch
    [[ $switch =~ ^[Yy] ]] && git checkout "$BRANCH_NAME" && log_success "Switched to $BRANCH_NAME"
else
    git checkout -b "$BRANCH_NAME" &
    spinner $!
    log_success "Created and switched to $BRANCH_NAME"
fi

log_success "Ready to work! Log saved: $LOG_FILE"
echo "📋 Session log: $LOG_FILE"
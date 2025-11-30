# Project Starter Script 🚀

<div align="center">
<img src="assets/img/Project_Starter_Script_blue_logo_v2.webp" alt="Project Starter Script Logo" width="350">
<br>

![Language](https://img.shields.io/badge/Language-Bash-lightgrey.svg) 
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)
![Lint Status](https://github.com/KnowOneActual/Project_Starter_Script/actions/workflows/lint.yml/badge.svg)
![CI Status](https://github.com/KnowOneActual/Project_Starter_Script/actions/workflows/ci.yml/badge.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-Yep-brightgreen.svg)
</div>
<br>

## ✨ **New Enhanced Features (v2.0)**

- **🐌 `--dry-run`** Preview all actions without executing
- **⏳ Progress Spinners** Visual feedback during downloads/git ops
- **📋 Session Logging** `work-session-YYYYMMDD-HHMMSS.log` for every session
- **🔍 Dependency Checks** Validates git/curl/jq before starting
- **📊 Full CI/CD** Matrix testing + GitHub Pages deployment
- **🎨 Enhanced UX** Colors, interactive menus, strict sanitization

## 🚀 Quick Start

```bash
# New project with dry-run preview
./start-project.sh --dry-run my-app

# Start work with fast-track
./start-work.sh feature login-page

# Interactive work session (creates log file)
./start-work.sh
```

## Features

- **📁 Standard Structure**: `src/`, `docs/`, `tests/` + language detection
- **🐍 Smart Setup**: Python `.venv`, Node `package.json` + `.nvmrc`
- **🔧 Auto-Fix Names**: "My New App" → `my-new-app`
- **✅ CI/CD Ready**: ShellCheck, matrix testing, template validation
- **🌐 GitHub Integration**: `gh repo create` or manual remote setup
- **📦 Companion Tools**: Enhanced `start-work.sh` with logging/menus

## Prerequisites

```bash
# Core dependencies
sudo apt install git curl jq shellcheck  # Ubuntu/Debian
brew install git curl jq shellcheck      # macOS

# Optional: GitHub CLI
gh auth login
```

## Usage

### 1. **Project Creation**
```bash
# Interactive (recommended)
./start-project.sh

# Direct with name
./start-project.sh my-project

# Safe preview first
./start-project.sh --dry-run my-project
```

### 2. **Daily Workflow** (`start-work.sh`)
```bash
# Fast-track (auto-sanitizes)
./start-work.sh feature user-auth
# → Creates: feature/user-auth + logs session

# Interactive menu
./start-work.sh
# → Select type → Enter name → Creates log file
```

**💾 Logs saved as**: `work-session-20251129-1915.log`

## 🎯 Example Session
```
$ ./start-work.sh feature login
[2025-11-29 19:15:23] INFO: Starting work session
[2025-11-29 19:15:24] SUCCESS: Created feature/login
📋 Session log: work-session-20251129-191523.log
```

## 🧪 CI/CD Pipeline

| Job | Triggers | Checks |
|-----|----------|--------|
| Lint | Push/PR | ShellCheck, EditorConfig |
| Test | Push/PR | Script syntax matrix |
| Templates | Push/PR | Structure validation |
| Pages | Main push | Auto-deploy docs |

**[View Actions](https://github.com/KnowOneActual/Project_Starter_Script/actions)**

## 📚 Advanced Usage

```bash
# 1. Dry-run new project
./start-project.sh --dry-run "My App With Spaces"

# 2. Start feature work (creates log)
cd my-app-with-spaces
../start-work.sh bugfix oauth-bug

# 3. CI runs automatically on push/PR
```

## 🔧 Customization

- **Templates**: Edit `templates/` for custom boilerplates
- **BASE_URL**: Override repo for enterprise GitHub
- **Branch Types**: Extend `select_branch_type()` function

## 📈 Release History

See [CHANGELOG.md](CHANGELOG.md) for v1.1.0 → v2.0 upgrades.

---

**MIT License** - [LICENSE](LICENSE)

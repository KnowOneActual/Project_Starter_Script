# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Full `ROADMAP.md` with phased development plan
- VS Code integration roadmap

## [v2.0.0] - 2025-11-29
### Added
- 🚀 **`start-project.sh`** - Complete project scaffolding
  - `src/`, `tests/`, `docs/` structure
  - README, CHANGELOG, CONTRIBUTING, LICENSE
  - GitHub templates (ISSUE_TEMPLATE, PR_TEMPLATE)
  - Language-specific `.gitignore` + setup (Python/Node/Go)
  - Initial git commit + `gh repo create`
- ✨ **`start-work.sh`** - Git workflow automation
  - Auto-stash uncommitted changes w/ spinner
  - Numbered branch type menu (feature/bugfix/hotfix)
  - Smart branch name cleaning (`super-cool-thing`)
  - Sync main → create/switch branch
- 🎨 **Production UX**
  - Spinners, colors, clear `>>>` prompts
  - No stalls, no invisible prompts
  - Cross-platform color detection

### Fixed
- 🔧 **ShellCheck 100% clean** (SC2034, SC2183, syntax)
- 🐛 Branch name sanitization (no trailing `-`)
- 🐛 Spinner line artifacts (`\r\033[K`)
- 🐛 Prompt visibility (newlines + `>>>` prefixes)

### CI/CD
- ✅ GitHub Actions w/ dual ShellCheck (2.0.0 + master)
- ✅ Linux/macOS compatibility checks

## [v1.0.0] - 2025-11-?? *(Estimated)*
### Added
- Initial `start-project.sh` prototype
- Basic templates + git init

*Full history available in git log.*


## [1.3.0]

### Added
- **Workflows**: Added `.github/workflows/lint.yml` to automatically lint Bash scripts with ShellCheck on every push.
- **start-project.sh**: Added a `gh auth status` check to verify authentication before attempting to create a GitHub repository.
- **start-project.sh**: Added support for overriding the `BASE_URL` environment variable, making it easier for forks to test changes using their own templates.
- - **start-project.sh**: Added a validation step using `gh auth status` to ensure the user is actually logged into the GitHub CLI before attempting to create a repository.

### Fixed
- **start-project.sh** fixed input error hanlding with the auto-fix logic.
- **start-project.sh**: Fixed a critical issue where `curl` would silently fail on 404 errors. Added the `-f` flag to `download_file` to correctly catch and report errors.
- **start-project.sh**: Refactored the GitHub push and `.gitignore` selection prompts to use `while` loops, preventing invalid input (like typos) from breaking the script flow.
- **start-work.sh**: Fixed the "stash changes" prompt to use a loop, ensuring the script doesn't exit immediately if the user mistypes their choice.


## [1.2.0]

### Added
- **start-work.sh**: Added support for command-line arguments (e.g., `./start-work.sh feature my-task`) to bypass interactive menus for faster usage.
- **start-work.sh**: Added automatic input sanitization to prevent Git errors by converting spaces to hyphens and forcing lowercase branch names.
- **start-work.sh**: Added a proactive check to detect if a target branch already exists locally, offering to switch to it safely instead of aborting.

### Fixed
- **start-work.sh**: Fixed a logic error where the script would incorrectly report "Success" even if the `git checkout` command failed due to invalid characters.

## [1.1.0]

### Added
- **start-project.sh**: Added "Pre-flight Checks" to automatically verify that `git` and `curl` are installed before running.
- **start-project.sh**: Added automatic environment setup for Python (creates `.venv` and `requirements.txt`) and Node.js (initializes `package.json` and `.nvmrc`).
- **start-project.sh**: Added CI/CD integration by fetching a default GitHub Actions workflow (`ci.yml`) for new projects.
- **Templates**: Introduced a `templates/` directory to host generic versions of `CONTRIBUTING.md`, `CHANGELOG.md`, and `ci.yml`.

### Changed
- **start-project.sh**: Refactored download logic to pull documentation from the new `templates/` directory, ensuring new projects start with a clean history instead of cloning this script's own docs.
- **start-work.sh**: Updated logic to auto-detect the default branch name (e.g., `main` or `master`) from the remote, removing the hardcoded dependency on `main`.


## [1.0.0]

### Added
- **start-project.sh**: Added support for command-line arguments (e.g., `./start-project.sh my-app`) to skip the initial prompt.
- **start-project.sh**: Added safety checks to prevent overwriting existing directories and using invalid characters in project names.
- **start-project.sh**: Added a `download_file` helper function to streamline external file fetching.
- **start-work.sh**: Added an "auto-stash" feature to safely save uncommitted changes instead of exiting.
- **start-work.sh**: Added a branch type selection menu (Feature, Bugfix, Hotfix) for standardized naming.
- **.prettierrc**: Added `endOfLine: lf` to strictly enforce Linux line endings.

### Changed
- **start-project.sh**: Improved `git init` logic to support older Git versions that don't recognize the `-b` flag.
- **README.md**: Removed the "instructions currently in development" warning.

### Fixed
- **start-project.sh**: Fixed a syntax error in the `.prettierignore` download command.
- **.prettierrc**: Resolved merge conflicts and restored valid JSON formatting.


***

**Built with ❤️ by debugging real-world UX issues:**
- Invisible prompts
- Spinner artifacts  
- Branch name sanitization
- ShellCheck compliance
- Cross-platform colors
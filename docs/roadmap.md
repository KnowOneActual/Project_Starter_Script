# ROADMAP.md

## 🎯 **Project Starter Script - Future Enhancements**

**Current Status:** ✅ v2.0.0 - Production-ready, CI passing, battle-tested UX

***

## **Phase 1: Core Polish (Next Sprint)**

### **High Impact, Low Effort**
- [ ] **start-project.sh**
  - ✅ Full MIT LICENSE (replace placeholder text)
  - [ ] Add `SECURITY.md` template
  - [ ] `.github/workflows/stale.yml` (auto-close stale issues)
  - [ ] Pre-commit hooks (`.pre-commit-config.yaml`)
  - [ ] `CODE_OF_CONDUCT.md`

- [ ] **start-work.sh** 
  - [ ] Add `gh pr create` integration (one-key PRs)
  - [ ] Branch name validation preview before creating
  - [ ] `git status` summary after switch

### **UX Discoveries from Testing**
```
PROBLEM: Invisible prompts → SOLUTION: >>> prefixes + newlines
PROBLEM: Branch name pollution → SOLUTION: Simple numbered menus
PROBLEM: Spinner line artifacts → SOLUTION: \r\033[K + printf '\n'
```

***

## **Phase 2: Multi-Language Power (1-2 Sprints)**

```
[ ] Python: poetry/pipenv support + pyproject.toml
[ ] Node: pnpm support + turbo.json  
[ ] Rust: cargo new + rustfmt.toml
[ ] Go: goreleaser config
[ ] Docker: Dockerfile + docker-compose.yml
[ ] CLI: clap/typer scaffolding
```

**Smart Language Detection:**
```bash
# Detect from .nvmrc, Cargo.toml, go.mod, pyproject.toml
detect_language() { ... }
```

***

## **Phase 3: Enterprise Features (2-3 Sprints)**

```
[ ] GitHub App integration (no gh CLI needed)
[ ] Team workflows (require review branches)
[ ] Monorepo support (apps/ packages/ )
[ ] Cloud deployment templates (Vercel, Fly.io, Railway)
[ ] Analytics (optional GitHub telemetry)
[ ] Plugin system (custom templates)
```

***

## **Phase 4: Ecosystem (Ongoing)**

```
[ ] VS Code extension (one-click setup)
[ ] npm/pip/brew package ("npx create-project-starter")
[ ] GitHub Action marketplace
[ ] Template gallery (showcase community templates)
[ ] CLI mode (no interactivity for CI/CD)
```

***

## **Metrics for Success**

```
📊 Week 1: 10 stars, 5 forks
📊 Month 1: 100 stars, npm package live  
📊 Month 3: 500 stars, VS Code extension
📊 Month 6: 2k stars, featured in "awesome" lists
```

***

## **Technical Debt (Must Fix)**

```
🔧 ShellCheck: 100% clean (DONE!)
🔧 License: Full MIT text
🔧 Error handling: Network failures, git errors
🔧 Testing: BATS test suite
🔧 Docs: Full API reference + screenshots
```

***

## **Stretch Goals ✨**

```
🌟 AI integration (Copilot workspace setup)
🌟 Self-updating scripts
🌟 VS Code + Cursor integration
🌟 Neovim + tmux presets
🌟 Mobile-first README templates
```

***

**Priority Order:** Phase 1 → Phase 2 → Merge PR → Release v2.1 → Phase 3

**Tag each release:** `git tag v2.1.0 && git push --tags`


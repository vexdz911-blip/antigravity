````instructions
<!-- Copilot / AI Agent Instructions (tailored to this workspace snapshot) -->

# Quick Orientation

Purpose: help an AI coding agent become productive in this repository snapshot by capturing discovered structure, useful commands, and project-specific cues.

Snapshot summary
- This workspace appears to contain primarily Git metadata under `lib/modules/.git` (partial checkout or submodule). No top-level source manifests (e.g., `package.json`, `pyproject.toml`) or full source tree were found.
- Notable files discovered: `.git/.vscode/launch.json`, `.git/.vscode/mcp.json` and the `lib/modules` directory (may contain modules in a full checkout).

Immediate actions for an agent
- Confirm the true project root with the user or search parent directories for the real repository contents.
- Run the commands in the "Quick checks" section below to locate manifests and source files.

Quick checks (run these first)
```bash
# show git repo root
git rev-parse --show-toplevel || echo "no repo root found"

# list tracked files (helpful for partial clones / submodules)
git ls-files --exclude-standard --cached | sed -n '1,200p'

# search for common manifests and agent docs
grep -R --line-number "AGENT.md\\|AGENTS.md\\|copilot-instructions.md\\|CLAUDE.md\\|README.md" . || true
```

Developer workflows and notes (discoverable from this snapshot)
- Build/Test: no build manifests were discovered here. If you locate a module under `lib/modules`, check for `package.json`, `pyproject.toml`, `setup.py`, or `go.mod` there to infer build/test commands.
- Debugging: this snapshot includes VS Code launch configs under `.git/.vscode/launch.json` and `.git/.vscode/mcp.json` — treat these as examples of how maintainers expect debugging/agent runs to be launched.

Project-specific conventions
- Treat the `.git` folder in this snapshot as metadata only — do not edit Git internals. If you find `.git/.vscode` configs, prefer copying relevant settings into workspace-level `.vscode` only after confirming the real project root.
- The presence of `mcp.json` indicates Model Context Protocol usage; preserve its structure when proposing changes to agent integration or launch tasks.

Integration points to look for when the full repo is present
- `lib/modules/*` — possible per-module packages. Look there for module manifests and per-module build scripts.
- `.github/workflows/*` — CI definitions (not present in this snapshot, check when you find the root).

Examples (from this snapshot)
- VS Code launch example: `.git/.vscode/launch.json`
- MCP config example: `.git/.vscode/mcp.json`

When you need clarification
- Ask the user: where is the intended project root? If available, point me to it and I will re-run discovery and expand these instructions with concrete build/test commands and code references.

Please review and tell me which of the following you'd like next:
- I should search parent directories for the real repo root.
- You will point me to the project root path.
- I should stop (you only needed this snapshot note).

-- End
<!-- Auto-generated guidance for AI coding agents. Please ask for clarifications. -->
# Copilot / AI Agent Instructions

Purpose
- Quick orientation for an AI coding agent to become productive in this repository snapshot.

What I discovered (from the current workspace)
- The workspace contains mainly Git metadata under `lib/modules/.git` (e.g. `FETCH_HEAD`, `index`).
- There is a `.vscode` config inside that `.git` folder: `.git/.vscode/launch.json` and `.git/.vscode/mcp.json`.
- No top-level README, build manifest (e.g., `package.json`, `pyproject.toml`), or AGENT/AGENTS/CLAUDE instruction files were found during a repo-wide search.

Immediate goals for an AI agent
- Confirm the true project root with the user (this workspace appears to contain only a nested `.git` directory).
- If the root is elsewhere, ask for its path or for permission to search parent directories.

How to quickly gather context (commands)
```bash
# Show current repo root (use in bash/WSL/git shell)
git rev-parse --show-toplevel || echo "no repo root found"

# List tracked files to see if there's more content elsewhere
git ls-files --exclude-standard --cached

# Search for common manifests and instruction files
ls -la
grep -R "AGENT.md\\|AGENTS.md\\|copilot-instructions.md\\|README.md" . || true
```

Big-picture guidance (how to reason about this repo snapshot)
- Treat this snapshot as incomplete: the presence of `.git` metadata without other source files indicates either a partial checkout, a submodule, or that you are inside a metadata folder.
- Prioritize: 1) Confirm repo root; 2) locate package manifests or top-level README; 3) identify language(s) and build tools.

Project-specific cues to watch for
- `.git/.vscode/mcp.json` — suggests Model Context Protocol (MCP) tooling or VS Code launch setups. When present, preserve any launcher settings if you propose changes to runtime or debugging flows.
- Any `lib/modules` directories (if populated) likely hold modular packages; inspect for `setup.py`, `pyproject.toml`, `package.json`, or `go.mod` to determine per-module build steps.

If you find code (next steps for code changes)
- Prefer small, focused edits. Reference existing config files (e.g., `.vscode/launch.json`) when adding or changing debug/run commands.
- If adding tests or CI instructions, look first for existing CI config under `.github/workflows/` before creating new workflows.

What NOT to assume
- Do not assume standard build tools (npm, pip, make) are present — confirm by locating manifests.
- Do not modify `.git` internals; treat them as metadata unless instructed otherwise.

When stuck, ask the user these concrete questions
- Where is the intended project root? (path)
- Are there missing files that should be present locally (README, manifests)?
- Do you want me to search parent directories for the real repo contents?

This file was generated by an automated scan of the current workspace. If you point me to the full project root I will merge additional repository-specific guidance and examples.

````
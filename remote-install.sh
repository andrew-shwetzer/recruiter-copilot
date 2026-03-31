#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────
# Recruiting Copilot — Installer
# Works for both Claude Code CLI and Claude Cowork
# ─────────────────────────────────────────────────────────

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

ok()   { echo -e "${GREEN}  ✓${RESET}  $1"; }
info() { echo -e "${CYAN}  ·${RESET}  $1"; }

echo ""
echo -e "  ${BOLD}Recruiting Copilot${RESET} — Installing..."
echo "  ────────────────────────────────────"
echo ""

# Clone or update the repo
REPO_DIR="$HOME/.recruiter-skills/repo"
if [ -d "$REPO_DIR/.git" ]; then
  info "Updating existing install..."
  cd "$REPO_DIR" && git pull --quiet origin main 2>/dev/null || true
  ok "Updated to latest"
else
  info "Downloading skills..."
  mkdir -p "$HOME/.recruiter-skills"
  git clone --quiet https://github.com/andrew-shwetzer/recruiter-copilot.git "$REPO_DIR"
  ok "Downloaded"
fi

count=0

# Install to Claude Code CLI (~/.claude/skills/)
if [ -d "$HOME/.claude" ]; then
  CLAUDE_SKILLS="$HOME/.claude/skills"
  mkdir -p "$CLAUDE_SKILLS"
  for skill_dir in "$REPO_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    cp -r "$skill_dir" "$CLAUDE_SKILLS/$skill_name"
    count=$((count + 1))
  done
  ok "Claude Code: $count skills installed"
fi

# Install to Claude Cowork (find the skills-plugin path)
COWORK_BASE="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
if [ -d "$COWORK_BASE" ]; then
  # Find the skills directory (navigate the UUID structure)
  COWORK_SKILLS=$(find "$COWORK_BASE" -maxdepth 3 -name "skills" -type d 2>/dev/null | head -1)
  if [ -n "$COWORK_SKILLS" ]; then
    cowork_count=0
    for skill_dir in "$REPO_DIR/skills"/*/; do
      skill_name="$(basename "$skill_dir")"
      cp -r "$skill_dir" "$COWORK_SKILLS/$skill_name"
      cowork_count=$((cowork_count + 1))
    done
    ok "Claude Cowork: $cowork_count skills installed"
  fi
else
  info "Claude Cowork not detected (that's fine, skills work in Claude Code)"
fi

# Create data directories
mkdir -p "$HOME/.recruiter-skills/data"/{leads,candidates,outreach,research,briefings,reverse-search,job-searches}
ok "Data directories ready"

echo ""
echo "  ────────────────────────────────────────────────────"
echo -e "  ${GREEN}${BOLD}Done.${RESET} Open Claude Cowork (or Code) and type:"
echo ""
echo -e "    ${CYAN}/setup${RESET}"
echo ""
echo "  11 skills work free. Full suite with API keys."
echo "  Restart Cowork if skills don't appear immediately."
echo "  ────────────────────────────────────────────────────"
echo ""

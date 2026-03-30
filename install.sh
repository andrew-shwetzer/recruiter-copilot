#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────
# Recruiting Copilot — One-Time Installer
# Installs the plugin for Claude Code / Cowork
# ─────────────────────────────────────────────────────────

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$HOME/.claude/plugins/cache/recruiter-marketplace/recruiter/latest"
COMMANDS_SRC="$SCRIPT_DIR/commands"
DATA_DIR="$HOME/.recruiter-skills/data"

# ── Colors ───────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

ok()   { echo -e "${GREEN}  ✓${RESET}  $1"; }
info() { echo -e "${CYAN}  ·${RESET}  $1"; }
warn() { echo -e "${YELLOW}  !${RESET}  $1"; }

echo ""
echo -e "  ${BOLD}Recruiting Copilot${RESET} — Installer v2.0"
echo "  ────────────────────────────────────"
echo ""

# ── 1. Check Claude is installed ─────────────────────────
if [ ! -d "$HOME/.claude" ]; then
  warn "Claude Code / Cowork doesn't appear to be installed."
  warn "Install it first: https://claude.ai/code"
  exit 1
fi
ok "Claude detected"

# ── 2. Install as plugin ─────────────────────────────────
info "Installing plugin..."

mkdir -p "$PLUGIN_DIR/.claude-plugin"
mkdir -p "$PLUGIN_DIR/commands"

# Copy plugin manifest
cp "$SCRIPT_DIR/.claude-plugin/plugin.json" "$PLUGIN_DIR/.claude-plugin/"

# Copy all commands
for cmd in "$COMMANDS_SRC"/*.md; do
  cp "$cmd" "$PLUGIN_DIR/commands/"
done

# Copy MCP config if exists
if [ -f "$SCRIPT_DIR/.mcp.json" ]; then
  cp "$SCRIPT_DIR/.mcp.json" "$PLUGIN_DIR/"
fi

cmd_count=$(ls "$COMMANDS_SRC"/*.md 2>/dev/null | wc -l | tr -d ' ')
ok "Plugin installed ($cmd_count commands)"

# ── 3. Also install as standalone skills (backup) ────────
info "Installing standalone skills..."
CLAUDE_SKILLS="$HOME/.claude/skills"
mkdir -p "$CLAUDE_SKILLS"

if [ -d "$SCRIPT_DIR/skills" ]; then
  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    cp -r "$skill_dir" "$CLAUDE_SKILLS/$skill_name"
  done
  ok "Standalone skills installed"
else
  info "No standalone skills directory (plugin-only install)"
fi

# ── 4. Create data directories ───────────────────────────
mkdir -p "$DATA_DIR"/{leads,candidates,outreach,research,briefings,reverse-search,job-searches}
ok "Data directories ready"

# ── 5. Done ──────────────────────────────────────────────
echo ""
echo "  ────────────────────────────────────────────────────"
echo -e "  ${GREEN}${BOLD}Installed.${RESET} Open Claude Code or Cowork and run:"
echo ""
echo -e "    ${CYAN}/setup${RESET}        Set up your profile + API keys"
echo -e "    ${CYAN}/connect${RESET}      Connect email, ATS, calendar"
echo ""
echo "  8 skills work free. Add API keys to unlock the full suite."
echo ""
echo -e "  ${CYAN}/help${RESET} for the full skill list."
echo "  ────────────────────────────────────────────────────"
echo ""

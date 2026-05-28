#!/usr/bin/env bash
# Install china-compliance-skills to your AI agent's skills directory
# Supports: Claude Code, Cursor, Codex CLI, Gemini CLI, OpenClaw, and more
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/feichangai-team/china-compliance-skills/main/scripts/install.sh | sh
#
# Or clone manually:
#   git clone https://github.com/feichangai-team/china-compliance-skills.git ~/.agents/skills/china-compliance-skills

set -e

REPO="feichangai-team/china-compliance-skills"
SKILL_NAME="china-compliance-skills"

echo "🛡️ Installing China Compliance Skills..."

# Detect install paths
INSTALLED=()

# Universal path (Codex CLI, Gemini CLI, Kiro, etc.)
if [ -d "$HOME/.agents/skills" ] || mkdir -p "$HOME/.agents/skills" 2>/dev/null; then
  TARGET="$HOME/.agents/skills/$SKILL_NAME"
  if [ -d "$TARGET" ]; then
    echo "  → Updating $TARGET"
    cd "$TARGET" && git pull -q
  else
    echo "  → Cloning to $TARGET"
    git clone -q "https://github.com/$REPO.git" "$TARGET"
  fi
  INSTALLED+=("$TARGET")
fi

# Claude Code / VS Code Copilot
if [ -d "$HOME/.claude/skills" ] || mkdir -p "$HOME/.claude/skills" 2>/dev/null; then
  TARGET="$HOME/.claude/skills/$SKILL_NAME"
  if [ -d "$TARGET" ]; then
    echo "  → Updating $TARGET"
    cd "$TARGET" && git pull -q
  else
    echo "  → Cloning to $TARGET"
    git clone -q "https://github.com/$REPO.git" "$TARGET"
  fi
  INSTALLED+=("$TARGET")
fi

# Cursor (per-project hint)
echo ""
echo "✅ Installed to ${#INSTALLED[@]} location(s):"
for loc in "${INSTALLED[@]}"; do
  echo "   $loc"
done

echo ""
echo "📋 To use in your AGENTS.md or CLAUDE.md, add:"
echo ""
echo "   ## Skills"
echo "   - cn-compliance-guard: Scan Chinese text for 200+ banned words (广告法)"
echo "   - cn-ai-visibility: Check brand visibility in 5 Chinese AI search engines"
echo "   - cn-data-export: Assess cross-border data transfer compliance (PIPL)"
echo "   - cn-aigc-detector: Detect AI-generated Chinese text"
echo ""
echo "🛡️ China Compliance Skills installed successfully!"

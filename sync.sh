#!/usr/bin/env bash
# 把本工作副本同步进 Claude Code 已安装的插件缓存。
#
# 用法：在本目录执行 ./sync.sh   之后重启 Claude Code 生效。
#
# 同步前三道闸门，任一命中即拒绝（防止 merge 上游时把遥测/注入带回来）：
#   1. 遥测端点重新出现
#   2. 已删除的遥测文件重新出现
#   3. hooks 层重新出现（注入 + 会话内容落盘的来源）
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${PUA_PLUGIN_CACHE:-$HOME/.claude/plugins/cache/pua-clean/pua/3.5.0-clean}"

fail() { printf '\033[31m✗ %s\033[0m\n' "$1" >&2; exit 1; }

# 闸门 1：遥测端点
hits="$(grep -rIl -E 'pua-skill\.pages\.dev|agentguard\.workers\.dev' "$SRC" \
          --exclude-dir=.git --exclude=CLEAN.md --exclude=sync.sh 2>/dev/null || true)"
if [ -n "$hits" ]; then
  printf '\033[31m✗ 遥测端点重新出现，已拒绝同步：\033[0m\n' >&2
  printf '%s\n' "$hits" | sed 's|^'"$SRC"'/|    |' >&2
  exit 1
fi

# 闸门 2：已删除的遥测文件
for f in skills/pua/references/platform.md skills/pua/references/survey.md \
         commands/survey.md landing landing.html; do
  [ -e "$SRC/$f" ] && fail "已删除的遥测文件重新出现：$f"
done

# 闸门 3：hooks 层（上下文注入 + 会话内容落盘）
[ -e "$SRC/hooks" ] && fail "hooks/ 重新出现——该层会向上下文注入文本并把会话内容写进 ~/.pua/"

[ -d "$(dirname "$DEST")" ] || fail "插件缓存父目录不存在：$(dirname "$DEST")（插件是不是没装？）"

rm -rf "$DEST"
cp -r "$SRC" "$DEST"
rm -rf "$DEST/.git" "$DEST/sync.sh"

printf '\033[32m✓ 三道闸门通过，已同步\033[0m\n'
printf '  源   %s\n' "$SRC"
printf '  目标 %s\n' "$DEST"
printf '  skills %s / commands %s / agents %s / hooks %s\n' \
  "$(ls "$DEST/skills" | wc -l)" "$(ls "$DEST/commands" | wc -l)" \
  "$(ls "$DEST/agents" | wc -l)" "$([ -d "$DEST/hooks" ] && ls "$DEST/hooks" | wc -l || echo 0)"
printf '\n重启 Claude Code 生效。改动要防重装丢失，记得 git push。\n'

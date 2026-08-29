#!/usr/bin/env bash
# 把本工作副本同步进 Claude Code 已安装的插件缓存。
#
# 用法：在本目录执行 ./sync.sh
# 之后重启 Claude Code 生效。
#
# 同步前有两道闸门，任一命中即拒绝同步（防止 merge 上游时把遥测带回来）：
#   1. 出现已删除的遥测端点
#   2. 已删除的遥测文件重新出现
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${PUA_PLUGIN_CACHE:-$HOME/.claude/plugins/cache/pua-clean/pua/3.5.0-clean}"

fail() { printf '\033[31m✗ %s\033[0m\n' "$1" >&2; exit 1; }

# 闸门 1：端点扫描
hits="$(grep -rIl -E 'pua-skill\.pages\.dev|agentguard\.workers\.dev' "$SRC" \
          --exclude-dir=.git --exclude=CLEAN.md --exclude=sync.sh 2>/dev/null || true)"
if [ -n "$hits" ]; then
  printf '\033[31m✗ 遥测端点重新出现，已拒绝同步：\033[0m\n' >&2
  printf '%s\n' "$hits" | sed 's|^'"$SRC"'/|    |' >&2
  exit 1
fi

# 闸门 2：已删除的遥测文件
for f in hooks/heartbeat.sh hooks/stop-feedback.sh hooks/sanitize-session.sh \
         skills/pua/references/platform.md skills/pua/references/survey.md \
         commands/survey.md landing; do
  [ -e "$SRC/$f" ] && fail "已删除的遥测文件重新出现：$f"
done
grep -q 'heartbeat\.sh\|stop-feedback\.sh' "$SRC/hooks/hooks.json" \
  && fail "hooks.json 重新注册了遥测钩子"

[ -d "$(dirname "$DEST")" ] || fail "插件缓存父目录不存在：$(dirname "$DEST")（插件是不是没装？）"

rm -rf "$DEST"
cp -r "$SRC" "$DEST"
rm -rf "$DEST/.git" "$DEST/sync.sh"

printf '\033[32m✓ 两道闸门通过，已同步\033[0m\n'
printf '  源  %s\n' "$SRC"
printf '  目标 %s\n' "$DEST"
printf '  skills %s / commands %s / agents %s / hooks %s\n' \
  "$(ls "$DEST/skills" | wc -l)" "$(ls "$DEST/commands" | wc -l)" \
  "$(ls "$DEST/agents" | wc -l)" "$(ls "$DEST/hooks" | wc -l)"
printf '\n重启 Claude Code 生效。改动要跨机器/防重装丢失，记得 git push。\n'

---
name: pua-hooks-layer-removed
description: 本 fork 已删掉整个 hooks/ 层，/pua:on 的 always_on 与 /pua:pua-loop 随之失效；dd 冷启动时不要再去建 ~/.pua/config.json。
metadata:
  node_type: memory
  type: project
  modified: 2026-08-29
---

commit `ed6ce59`（2026-08-29）把 `hooks/` 整层从本仓库删除——`session-restore.sh` / `frustration-trigger.sh` / `integrity-guard.sh` / `pua-loop-hook.sh` / `failure-detector.sh` / `subagent-teardown.sh` / `flavor-helper.sh` / `hooks.json`。界线写在 `CLEAN.md` 「三之二」节：hook = 未经请求的上下文注入 + 把会话内容写盘，整层删；skill / command 要用户主动敲 `/pua:xxx` 才加载，保留。

后果：`always_on`（`/pua:on`）与 `/pua:pua-loop` 依赖已删的 hook，在本仓库不再有代码可执行。`~/.claude/pua/` 已删。

**别被 `~/.pua/` 里的残留骗到**：`.failure_count` / `.peak_pressure_level` 等状态文件仍在被刷新，但那不是仓库还有 hooks——已验证 `~/.claude/plugins/marketplaces/pua-clean/hooks/hooks.json` 仍存在，即**已安装副本尚未跟上仓库**。跑 `./sync.sh` 才会同步，同步后需重启客户端。

**How to apply:** dd 的 `SKILL.md` 第 3 条要求「加载 dd 即确保 PUA 常驻（`~/.pua/config.json` 的 `always_on=true`）」——在本工作区**跳过那一步**，那是给已删代码写配置文件。按 dd 自己写明的退化路径走：`#NG` 的否定性结论闸门 + `#CODE` 的 `missing` 自检。

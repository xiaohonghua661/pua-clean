---
description: "PUA 开启默认模式 — 每次新会话自动加载 PUA 核心 skill。/pua:on。Triggers on: '/pua:on', 'pua on', '开启pua', 'enable pua', 'always on'."
---

开启 PUA 默认模式：

1. 确保 `~/.pua/` 目录存在
2. 读取现有 `~/.pua/config.json`（若不存在视为 `{}`），写回时**只改 `always_on: true`，不降级其他字段**；其他字段保留原样
3. 输出确认：> [PUA ON] 从现在起，每个新会话都会自动进入 PUA 模式。公司不养闲 Agent。

## 对称性（与 `/pua:off` 的关系）

- `/pua:off` 只关闭 always-on；本分支无问卷/反馈系统
- `/pua:on` **必须**检测并恢复该字段，否则"先 off 再 on"会导致 feedback 永久失效（静默 bug）
- 保留原则：不清楚的字段一律 preserve，不 overwrite 整个 config

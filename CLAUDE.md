# pua-clean

先完整遵循同目录 `AGENTS.md`（冷启动流程、必读清单、记忆落点、项目扩展全在那儿）。
本文件只补 Claude Code 专属的执行差异。

## 记忆（#MEM）

冷启动读 `.collab/memory/MEMORY.md` 与 `.collab/claude/memory/MEMORY.md`（纯指针索引），按需再取正文。
跨会话事实一律写本工作区 `.collab/`，**不写 home 下任何记忆池**——那里按工作区绝对路径分键，工作区一搬就对不上，等于没记。

## 中间物

验收沙箱、一次性脚本、备份等中间物写 `<工作区>/temp/`，不写 home 下的 scratchpad——同上，搬工作区时带不走。

## Claude 专属差异

（当前无）

# pua-clean

本项目用 [dd](https://github.com/JustLikeCheese/dd) 管理规约。

## 冷启动（agent 必读，不可跳）

1. **Read 全 `docs/必读/`** —— 本项目选装的核心规约子集
2. `/dd` 加载 dd skill 拿触发字系统
3. 按需 `dd get <TAG>` 拉未选装 tag

## 项目必读清单

- `#DOC`（文档编写）— `docs/必读/文档编写.md`
- `#TEST`（测试流程）— `docs/必读/测试流程.md`
- `#CODE`（项目编写）— `docs/必读/项目编写.md`
- `#MEM`（记忆规约）— `docs/必读/记忆规约.md`
- `#GIT`（上传发布）— `docs/必读/上传发布.md`
- `#SCOPE`（改动边界）— `docs/必读/改动边界.md`
- `#NG`（拒绝猜想）— `docs/必读/拒绝猜想.md`

## 记忆落点（#MEM）

冷启动读 `.collab/memory/MEMORY.md` 与 `.collab/<本AI>/memory/MEMORY.md`（纯指针索引），按需再取正文。
跨会话事实一律写本工作区 `.collab/`：`memory/` = 所有 AI 共享，`claude/memory/`、`codex/memory/` = 该 AI 专属；一事一文件 + frontmatter，增删改文件同步该目录 `MEMORY.md` 一行。
只许 `Edit` 追加或改节，写前先重读；禁止整篇覆盖。
不写 home 下任何记忆池——那里按工作区绝对路径分键，工作区一搬就对不上。收尾前自检本会话跨会话事实是否已落 `.collab/`。

## 中间物落点

验收沙箱、一次性脚本、备份、试跑产物写 `<工作区>/temp/`（已 gitignore），不写宿主 CLI 在 `%TEMP%` / `/tmp` 下的 scratchpad——那里搬工作区时带不走。确定不需要留的一次性中转不在此限。

## 联网检索

搜索走 dd 注册的 SearXNG，不用 CLI 内置搜索：`dd mcp call searxng searxng_web_search '{"query":"…"}'`（Claude Code 重启后可直接用 `mcp__searxng__*`）。读网页正文用同服务的 `web_url_read` 拿原始 markdown——内置 fetch 经小模型转述，抄配置/API 会抄错。
`dd mcp list` 里没有 searxng 就照 `dd get MCP` 补，**别默默退回内置搜索**。

## 项目扩展

项目额外 tag skill 使用项目实际选定的目录或单个 Markdown；用 `DD_DOCS` / `--docs` 指定，frontmatter `name` 匹配即覆盖全局同名。

## 触发字全表

运行 `dd list`；或 `dd get <TAG>` 直接拉正文。

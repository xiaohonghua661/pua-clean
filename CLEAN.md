# CLEAN.md — 本 fork 移除了什么

`xiaohonghua661/pua-clean` 是 [`tanweai/pua`](https://github.com/tanweai/pua) v3.5.0 的**去遥测分支**。

上游插件在三个层面向外发送数据。本分支把它们从**源码里删掉**，不是用开关关闭——
`offline` / `telemetry` / `feedback_frequency` 之类的配置项即使被改回去，也没有代码可执行。

## 一、删除的联网行为

| 上游行为 | 触发方式 | 发往 | 本分支处理 |
|---|---|---|---|
| 静默心跳 | `SessionStart` hook，**不询问用户** | `pua-skill.pages.dev/api/heartbeat` | 删除 `hooks/heartbeat.sh` 并从 `hooks.json` 注销 |
| Session 上传 | `Stop` hook 注入 prompt，诱导模型弹窗征求同意 | `pua-skill.pages.dev/api/upload` | 删除 `hooks/stop-feedback.sh` + `hooks/sanitize-session.sh` 并注销 |
| 评分上报 | 同上 | `pua-skill.pages.dev/api/feedback` | 同上 |
| 排行榜注册与静默提交 | `/pua 排行榜`，收集**邮箱 + 手机号** | `pua-skill.pages.dev/api/leaderboard` | 从 `skills/pro/SKILL.md`、`skills/shot/SKILL.md` 删除整节 |
| 短信注册换 token | skill 指示模型执行 | `pua-api.agentguard.workers.dev/v1/sms/send`、`/v1/register` | 删除 `skills/pua/references/platform.md` |
| **远端指令拉取后执行** | skill 指示模型拉 `prompt_template` 并执行 | `pua-api.agentguard.workers.dev/v1/command/<id>` | 同上 |
| 统计上报 | 会话开始 / 每次 PUA 触发 / 每次用指令，注明"静默执行，不输出给用户" | `pua-api.agentguard.workers.dev/v1/stats` | 同上 |
| 付费与二维码 | `/pua 升级` | `.../v1/plans`、`/v1/payment/create`、`/v1/payment/verify` | 同上 |
| 调研问卷上传 | `/pua:survey` | `pua-skill.pages.dev/api/feedback` | 删除 `commands/survey.md` + `skills/pua/references/survey.md` |

其中**远端指令拉取后执行**是最需要注意的一条：上游 `platform.md` 指示模型从服务端取回
`prompt_template` 字段并当作指令执行，等于把会话控制权交给了远端。

## 二、删除的文件

```
hooks/heartbeat.sh
hooks/stop-feedback.sh
hooks/sanitize-session.sh
skills/pua/references/platform.md
skills/pua/references/survey.md
commands/survey.md
landing/                      # Cloudflare Pages 数据收集后端
landing.html
evals/test-heartbeat.sh
evals/test-upload-flow.sh
evals/test-feedback-auth.sh
evals/test-issue-regressions.sh    # 断言依赖上述已删文件
evals/test-release-consistency.sh  # 同上
docs/plans/2026-05-09-silent-heartbeat-design.md
```

## 三、修改的文件

- `hooks/hooks.json` — 注销 `SessionStart`（两处 matcher）的 heartbeat、`Stop` 的 stop-feedback
- `skills/pua/SKILL.md` — 删除"静默上报 `pua_triggered`"、整节"任务完成反馈"
- `skills/pro/SKILL.md` — 删除"统计上报"、"首次注册/远端配置刷新"、整节"PUA 排行榜"
- `skills/shot/SKILL.md` — 删除"统计上报"、整节"PUA Platform 层"
- `commands/pua.md` — 删除 survey 路由，改写 offline 说明
- `commands/offline.md` — 改写为兼容保留说明
- `docs/FAQ.md` — 删除 heartbeat / 上传 / feedback endpoint 三节
- `plugin.json`、`.claude-plugin/plugin.json` — 版本 `3.5.0-clean`，指向本 fork
- `.claude-plugin/marketplace.json` — marketplace 名改为 `pua-clean`（避免与已安装的 `pua-skills` 冲突）

## 四、保留了什么

PUA 本身的功能全部保留：15 种大厂味道、压力升级、7 项检查清单、证据优先的完成校验、
P7/P9/P10 agent 团队、方法论路由、`/pua:loop`、Compaction 状态续接，以及全部本地 hook
（`frustration-trigger` / `failure-detector` / `session-restore` / `integrity-guard` /
`pua-loop-hook` / `subagent-teardown`）。这些 hook 只读写 `~/.pua/` 下的本地文件。

## 五、验证方法

```bash
grep -rIn -E 'pua-skill\.pages\.dev|agentguard\.workers\.dev' . --exclude-dir=.git
```

应无输出（CLEAN.md 自身除外）。

## 六、与上游的关系

上游 CI（`.github/workflows/release.yml`）与部分 eval 依赖已删除的文件，在本 fork 上不会通过。
本分支面向本地使用，不面向发布。上游 MIT 许可与原作者署名保留在 `LICENSE`。

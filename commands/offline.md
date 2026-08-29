---
description: "PUA 离线模式（本分支为兼容保留）— 本 fork 已物理移除所有联网路径，离线是唯一行为。/pua:offline。Triggers on: '/pua:offline', '离线模式', '封闭网络', 'offline mode', 'no network'."
---

**本分支说明**：这是 `tanweai/pua` 的去遥测 fork。心跳上报、session 上传、排行榜、
远端指令拉取与付费流程已在代码层删除，不是靠开关关闭。本命令仅为兼容上游而保留，
执行后写入 `offline: true` 标记，行为上不产生任何差别。

## 执行

```bash
mkdir -p "$HOME/.pua"
PYTHON_BIN="$(command -v python3 2>/dev/null || command -v python 2>/dev/null)"
"$PYTHON_BIN" - <<'PY'
import json, os
path=os.path.expanduser('~/.pua/config.json')
try:
    data=json.load(open(path, encoding='utf-8'))
except Exception:
    data={}
data['offline']=True
data.setdefault('always_on', True)
with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write('\n')
PY
```

## 输出确认

> [PUA OFFLINE] 本分支已无任何联网路径（心跳/上传/排行榜/远端指令均已删除），离线是唯一行为。本地压力与验证协议不受影响。

## 设计边界

- 离线不等于 `/pua:off`：PUA 行为仍可开启。
- 本分支不会替用户禁止模型或其他工具联网；真正的网络隔离仍应由运行环境、防火墙或工具权限控制完成。

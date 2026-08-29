---
name: pua-offline
description: "PUA offline alias for Codex. Codex subcommand mapping for Claude Code /pua:offline style usage; invoke with $pua-offline."
license: MIT
---

# pua-offline

This is a Codex CLI alias for the Claude Code `/pua:offline` command.

Compatibility shim: this fork has no network paths at all. Set ~/.pua/config.json offline=true while preserving other fields. Then report [PUA OFFLINE].

When this alias changes `~/.pua/config.json`, preserve unknown fields and create `~/.pua/` if missing. Do not claim completion without command/output evidence.

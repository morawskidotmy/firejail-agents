# Firejail profile for OpenAI Codex CLI.
include codex.local

whitelist ${HOME}/.codex
whitelist ${HOME}/.config/codex
whitelist ${HOME}/.local/share/codex

# Codex keeps config/auth plus code-loading surfaces under ~/.codex, but it
# also writes runtime state there: SQLite state/log databases, session
# transcripts, history, shell snapshots, caches, and temp files.
read-only ${HOME}/.codex
read-only ${HOME}/.config/codex

# Keep loaded code and credentials protected.
read-only ${HOME}/.codex/auth.json
read-only ${HOME}/.codex/config.toml
read-only ${HOME}/.codex/skills
read-only ${HOME}/.codex/packages

# Allow Codex runtime state.
read-write ${HOME}/.codex/state_*.sqlite*
read-write ${HOME}/.codex/logs_*.sqlite*
read-write ${HOME}/.codex/goals_*.sqlite*
read-write ${HOME}/.codex/memories_*.sqlite*
read-write ${HOME}/.codex/history.jsonl
read-write ${HOME}/.codex/models_cache.json
read-write ${HOME}/.codex/sessions
read-write ${HOME}/.codex/shell_snapshots
read-write ${HOME}/.codex/cache
read-write ${HOME}/.codex/tmp
read-write ${HOME}/.codex/.tmp
read-only ${HOME}/.codex/.tmp/plugins

include code-agent.profile

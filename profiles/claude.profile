# Firejail profile for Anthropic Claude Code CLI.
include claude.local

whitelist ${HOME}/.claude
whitelist ${HOME}/.config/claude
whitelist ${HOME}/.config/anthropic

# Treat Claude home/config as code-loading surfaces.
read-only ${HOME}/.claude
read-only ${HOME}/.config/claude
read-only ${HOME}/.config/anthropic

# The claude launcher in ~/.local/bin is a symlink into here — protect the
# real binary, plus any agent/skill/MCP definitions loaded as code at runtime.
read-only ${HOME}/.local/share/claude
read-only ${HOME}/.claude/agents
read-only ${HOME}/.claude/commands
read-only ${HOME}/.claude/mcp

include code-agent.profile

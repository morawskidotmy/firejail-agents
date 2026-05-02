# Firejail profile for Anthropic Claude Code CLI.
include claude.local

whitelist ${HOME}/.claude
whitelist ${HOME}/.config/claude
whitelist ${HOME}/.config/anthropic

include code-agent.profile

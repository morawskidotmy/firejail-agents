# Firejail profile for OpenCode CLI.
include opencode.local

whitelist ${HOME}/.opencode
whitelist ${HOME}/.config/opencode
whitelist ${HOME}/.local/share/opencode

# Treat OpenCode home/config as code-loading surfaces (read-only).
# Note: ~/.local/share/opencode contains the SQLite database and must be writable.
read-only ${HOME}/.opencode
read-only ${HOME}/.config/opencode

include code-agent.profile

# Firejail profile for OpenCode CLI.
include opencode.local

whitelist ${HOME}/.opencode
whitelist ${HOME}/.config/opencode
whitelist ${HOME}/.local/share/opencode

# Treat OpenCode home/config as code-loading surfaces.
read-only ${HOME}/.opencode
read-only ${HOME}/.config/opencode
read-only ${HOME}/.local/share/opencode

include code-agent.profile

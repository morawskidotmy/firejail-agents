# Firejail profile for OpenCode CLI.
include opencode.local

whitelist ${HOME}/.opencode
whitelist ${HOME}/.config/opencode
whitelist ${HOME}/.local/share/opencode

# Treat OpenCode home/config as code-loading surfaces (read-only).
# Note: ~/.local/share/opencode contains the SQLite database and must be writable.
read-only ${HOME}/.opencode
read-only ${HOME}/.config/opencode

# Local OpenAI-compatible proxies (e.g. LiteLLM on 127.0.0.1:8000 for Vertex/Gemini)
# are reachable via loopback since the jail shares the host network namespace.
# Configure the provider baseURL with 127.0.0.1, not "localhost".

include code-agent.profile

# Firejail profile for the omp CLI (oh-my-pi coding agent).
include omp.local

whitelist ${HOME}/.omp
whitelist ${HOME}/.config/omp
whitelist ${HOME}/.bun
whitelist ${HOME}/.npm

# Freeze code-loading surfaces (plugins, unpacked agents).
# The binary lives in ~/.bun/bin/omp (frozen by code-agent.profile).
# Note: ~/.omp/agent contains SQLite databases and runtime state and must be writable.
read-only ${HOME}/.omp/plugins
read-only ${HOME}/.omp/agent/agents

# Local OpenAI-compatible proxies (e.g. LiteLLM on 127.0.0.1:8000 for Vertex/Gemini)
# are reachable via loopback since the jail shares the host network namespace.
# Configure the provider baseURL with 127.0.0.1, not "localhost".

include code-agent.profile

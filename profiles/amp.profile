# Firejail profile for the Amp CLI (Sourcegraph).
include amp.local

# Whitelist Amp's own config + skills dir.
whitelist ${HOME}/.amp
whitelist ${HOME}/.amp/state
whitelist ${HOME}/.config/amp
whitelist ${HOME}/.agents

# The agent must not be able to overwrite its own launcher binary — that
# would persist a backdoor that runs unsandboxed on the next `amp` invocation.
# Treat Amp's home/config as code-loading surfaces; allow writes only in state/.
read-only ${HOME}/.amp
read-write ${HOME}/.amp/state
read-only ${HOME}/.config/amp
read-only ${HOME}/.agents

include code-agent.profile

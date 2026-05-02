# Firejail profile for the Amp CLI (Sourcegraph).
include amp.local

# Whitelist Amp's own config + skills dir.
whitelist ${HOME}/.amp
whitelist ${HOME}/.config/amp
whitelist ${HOME}/.agents

include code-agent.profile

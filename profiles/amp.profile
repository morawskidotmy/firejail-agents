# Firejail profile for the Amp CLI (Sourcegraph).
include amp.local

# Whitelist Amp's own config/state.
whitelist ${HOME}/.amp
whitelist ${HOME}/.config/amp

# The agent must not be able to overwrite its own launcher binary — that
# would persist a backdoor that runs unsandboxed on the next `amp` invocation.
# The binary lives in ~/.amp/bin, so freeze just that. The rest of ~/.amp
# (e.g. file-changes/) and ~/.config/amp (settings.json + write-meta) MUST
# stay writable: Amp updates these on every startup and bails out with
# "Unexpected error inside Amp CLI" if they are read-only.
read-only ${HOME}/.amp/bin

include code-agent.profile

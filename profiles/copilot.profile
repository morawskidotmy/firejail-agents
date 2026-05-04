# Firejail profile for GitHub Copilot CLI.
include copilot.local

whitelist ${HOME}/.config/copilot
whitelist ${HOME}/.config/github-copilot
whitelist ${HOME}/.copilot
whitelist ${HOME}/.copilot/session-state

# Keep Copilot runtime/session scratch writable, but freeze config surfaces
# that can affect behavior outside the jail.
read-only ${HOME}/.config/copilot
read-only ${HOME}/.config/github-copilot
read-only ${HOME}/.copilot
read-write ${HOME}/.copilot/session-state

include code-agent.profile

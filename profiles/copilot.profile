# Firejail profile for GitHub Copilot CLI.
include copilot.local

whitelist ${HOME}/.config/copilot
whitelist ${HOME}/.config/github-copilot
whitelist ${HOME}/.copilot

include code-agent.profile

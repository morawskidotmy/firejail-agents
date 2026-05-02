# Firejail profile for Aider.
include aider.local

whitelist ${HOME}/.aider
whitelist ${HOME}/.aider.conf.yml
whitelist ${HOME}/.config/aider

include code-agent.profile

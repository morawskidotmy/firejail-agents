# Firejail profile for Aider.
include aider.local

whitelist ${HOME}/.aider
whitelist ${HOME}/.aider.conf.yml
whitelist ${HOME}/.config/aider

# Treat Aider home/config as code-loading surfaces.
read-only ${HOME}/.aider
read-only ${HOME}/.aider.conf.yml
read-only ${HOME}/.config/aider

include code-agent.profile

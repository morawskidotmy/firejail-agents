# Firejail profile for Google Gemini CLI.
include gemini.local

whitelist ${HOME}/.gemini
whitelist ${HOME}/.config/gemini
whitelist ${HOME}/.config/google-gemini

# Treat Gemini home/config as code-loading surfaces.
read-only ${HOME}/.gemini
read-only ${HOME}/.config/gemini
read-only ${HOME}/.config/google-gemini

include code-agent.profile

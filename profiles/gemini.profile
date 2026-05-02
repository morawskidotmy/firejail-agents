# Firejail profile for Google Gemini CLI.
include gemini.local

whitelist ${HOME}/.gemini
whitelist ${HOME}/.config/gemini
whitelist ${HOME}/.config/google-gemini

include code-agent.profile

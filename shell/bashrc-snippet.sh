# ▰▱▰▱▰  firejail-agents: BEGIN  ▰▱▰▱▰
# ───── Firejailed coding agents ────────────────────────────────────────────
# Each function jails its agent so it can only see:
#   1. $PWD (the directory you launch it from) and its subtree
#   2. that agent's own config dir + ~/.gitconfig + dev toolchain caches
#   3. nothing else in $HOME (no ~/.ssh, ~/.mozilla, password stores, …)
# To bypass the jail for one invocation:    nojail amp …
# To peek at what the jail sees:            firejail --profile=amp --whitelist="$PWD" ls ~

_code_agent_jail() {
    # _code_agent_jail <profile> <real-binary> [args…]
    local profile="$1" bin="$2"; shift 2
    local cwd
    cwd="$(cd -P -- "$PWD" && pwd)"   # absolute, symlink-resolved
    command firejail \
        --quiet \
        --profile="$HOME/.config/firejail/${profile}.profile" \
        --whitelist="$cwd" \
        --   "$bin" "$@"
}

# Helper: build a wrapper function for one agent if its binary exists.
_code_agent_wrap() {
    local name="$1" bin="$2"
    [ -x "$bin" ] || return 0
    # printf %q quotes safely under bash
    eval "$(printf '%s() { _code_agent_jail %s %q "$@"; }' "$name" "$name" "$bin")"
}

_code_agent_wrap amp     "$HOME/.amp/bin/amp"
_code_agent_wrap copilot "$HOME/.local/bin/copilot"
_code_agent_wrap claude  "$HOME/.local/bin/claude"
_code_agent_wrap gemini  "$HOME/.volta/bin/gemini"
_code_agent_wrap aider   "$(command -v aider 2>/dev/null)"

unset -f _code_agent_wrap

# Escape hatch: run an agent (or anything) with no jail, e.g.  nojail amp
nojail() { command "$@"; }
# ▰▱▰▱▰  firejail-agents: END  ▰▱▰▱▰

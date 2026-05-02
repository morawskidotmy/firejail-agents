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
    local cwd="${PWD:A}"   # absolute, symlink-resolved
    command firejail \
        --quiet \
        --profile="$HOME/.config/firejail/${profile}.profile" \
        --whitelist="$cwd" \
        --   "$bin" "$@"
}

# Find each agent's real binary once, then expose a wrapper function.
() {
    local name path
    for name path in \
            amp     "$HOME/.amp/bin/amp" \
            copilot "$HOME/.local/bin/copilot" \
            claude  "$HOME/.local/bin/claude" \
            gemini  "$HOME/.volta/bin/gemini" \
            aider   "$(command -v aider 2>/dev/null)"; do
        [[ -x "$path" ]] || continue
        eval "${name}() { _code_agent_jail ${name} ${(q)path} \"\$@\"; }"
    done
}

# Escape hatch: run an agent (or anything) with no jail, e.g.  nojail amp
nojail() { command "$@"; }
# ▰▱▰▱▰  firejail-agents: END  ▰▱▰▱▰

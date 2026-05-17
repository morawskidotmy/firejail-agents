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
    # Point in-jail podman at the host's rootless socket (option B).
    # Start it on the host with: systemctl --user enable --now podman.socket
    local sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    local container_host_env=()
    [ -S "$sock" ] && container_host_env=(--env="CONTAINER_HOST=unix://$sock")

    # Drop the firejail notice into $PWD so agents read it on startup.
    # Always link a dedicated FIREJAIL.md (so it coexists with any
    # project AGENTS.md). Additionally link AGENTS.md only when the
    # project doesn't already have one (so Amp/etc auto-pick it up
    # without clobbering the project's own).
    # Each cleanup only removes the file if it's still our symlink
    # pointing at our source — never a project-owned file.
    local notice_src="$HOME/.agents/firejail/AGENTS.md"
    local notice_firejail="$cwd/FIREJAIL.md"
    local notice_agents="$cwd/AGENTS.md"
    local firejail_installed=0 agents_installed=0
    if [ -f "$notice_src" ]; then
        if [ ! -e "$notice_firejail" ] && [ ! -L "$notice_firejail" ]; then
            ln -s "$notice_src" "$notice_firejail" 2>/dev/null && firejail_installed=1
        fi
        if [ ! -e "$notice_agents" ] && [ ! -L "$notice_agents" ]; then
            ln -s "$notice_src" "$notice_agents" 2>/dev/null && agents_installed=1
        fi
    fi
    _code_agent_cleanup_notice() {
        local target
        if [ "$firejail_installed" = "1" ] && [ -L "$notice_firejail" ]; then
            target="$(readlink "$notice_firejail" 2>/dev/null || true)"
            [ "$target" = "$notice_src" ] && rm -f "$notice_firejail"
        fi
        if [ "$agents_installed" = "1" ] && [ -L "$notice_agents" ]; then
            target="$(readlink "$notice_agents" 2>/dev/null || true)"
            [ "$target" = "$notice_src" ] && rm -f "$notice_agents"
        fi
    }
    trap _code_agent_cleanup_notice EXIT INT TERM HUP

    local rc=0
    command firejail \
        --quiet \
        --profile="$HOME/.config/firejail/${profile}.profile" \
        --whitelist="$cwd" \
        "${container_host_env[@]}" \
        --   "$bin" "$@" || rc=$?

    _code_agent_cleanup_notice
    trap - EXIT INT TERM HUP
    unset -f _code_agent_cleanup_notice
    return "$rc"
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

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
    # Point in-jail podman at the host's rootless socket (option B).
    # Start it on the host with: systemctl --user enable --now podman.socket
    local sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    local -a container_host_env
    [[ -S "$sock" ]] && container_host_env=(--env="CONTAINER_HOST=unix://$sock")

    # Drop the firejail notice into $PWD so agents read it on startup.
    # We only ever link FIREJAIL.md — never AGENTS.md — so we cannot
    # collide with or shadow a project's own AGENTS.md. Cleanup removes
    # the file only if it's still our symlink pointing at our source.
    local notice_src="$HOME/.agents/firejail/FIREJAIL.md"
    local notice_firejail="$cwd/FIREJAIL.md"
    local firejail_installed=0
    if [[ -f "$notice_src" && ! -e "$notice_firejail" && ! -L "$notice_firejail" ]]; then
        ln -s "$notice_src" "$notice_firejail" 2>/dev/null && firejail_installed=1
    fi
    _code_agent_cleanup_notice() {
        if [[ "$firejail_installed" == "1" && -L "$notice_firejail" ]]; then
            local target
            target="$(readlink "$notice_firejail" 2>/dev/null)"
            [[ "$target" == "$notice_src" ]] && rm -f "$notice_firejail"
        fi
    }
    trap _code_agent_cleanup_notice EXIT INT TERM HUP

    local rc=0
    command firejail \
        --quiet \
        --profile="$HOME/.config/firejail/${profile}.profile" \
        --whitelist="$cwd" \
        $container_host_env \
        --   "$bin" "$@" || rc=$?

    _code_agent_cleanup_notice
    trap - EXIT INT TERM HUP
    unset -f _code_agent_cleanup_notice
    return "$rc"
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

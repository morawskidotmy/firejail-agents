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
    # We only ever link FIREJAIL.md — never AGENTS.md — so we cannot
    # collide with or shadow a project's own AGENTS.md. Cleanup removes
    # the file only if it's still our symlink pointing at our source.
    local notice_src="$HOME/.agents/firejail/FIREJAIL.md"
    local notice_firejail="$cwd/FIREJAIL.md"
    local firejail_installed=0
    if [ -f "$notice_src" ] && [ ! -e "$notice_firejail" ] && [ ! -L "$notice_firejail" ]; then
        ln -s "$notice_src" "$notice_firejail" 2>/dev/null && firejail_installed=1
    fi
    _code_agent_cleanup_notice() {
        if [ "$firejail_installed" = "1" ] && [ -L "$notice_firejail" ]; then
            local target
            target="$(readlink "$notice_firejail" 2>/dev/null || true)"
            [ "$target" = "$notice_src" ] && rm -f "$notice_firejail"
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

# The set of jailed commands is derived from whatever profiles you have
# installed under ~/.config/firejail/<name>.profile. For each profile,
# the matching command must be resolvable via `command -v <name>` — i.e.
# on your $PATH. (Install agents into ~/.local/bin or symlink them there.)
# Drop in a new profile → wrapper appears next shell. Remove the profile →
# wrapper disappears. Base/included profiles (code-agent) are skipped.
_code_agent_profile_dir="${XDG_CONFIG_HOME:-$HOME/.config}/firejail"
if [ -d "$_code_agent_profile_dir" ]; then
    for _cap in "$_code_agent_profile_dir"/*.profile; do
        [ -e "$_cap" ] || continue           # no profiles installed
        _can="$(basename -- "$_cap" .profile)"
        case "$_can" in code-agent) continue ;; esac   # base profile, not an agent
        _cab="$(command -v "$_can" 2>/dev/null || true)"
        [ -n "$_cab" ] && [ -x "$_cab" ] || continue
        # printf %q quotes safely under bash
        eval "$(printf '%s() { _code_agent_jail %s %q "$@"; }' "$_can" "$_can" "$_cab")"
    done
fi
unset _code_agent_profile_dir _cap _can _cab

# Escape hatch: run an agent (or anything) with no jail, e.g.  nojail amp
nojail() { command "$@"; }
# ▰▱▰▱▰  firejail-agents: END  ▰▱▰▱▰

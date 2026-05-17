#!/usr/bin/env bash
# firejail-agents — install/update firejail profiles + shell wrappers for coding agents.
#
# Usage:   bash install.sh [--no-shell] [--shell=zsh|bash|both|auto]
#
#   --no-shell      install profiles only, skip shell rc edits
#   --shell=zsh     install zsh wrappers into ~/.zshrc
#   --shell=bash    install bash wrappers into ~/.bashrc
#   --shell=both    install into both
#   --shell=auto    detect from $SHELL (default)
#
# Idempotent + updating: re-running replaces the snippet block in your rc
# in-place (between the # firejail-agents: BEGIN / END markers), and overwrites any
# changed profile in ~/.config/firejail/ (a single .bak is kept the first
# time a divergent file is found).

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" && pwd)"
cd "$SCRIPT_DIR"

# --- args ------------------------------------------------------------------
INSTALL_SHELL="auto"
for arg in "$@"; do
    case "$arg" in
        --no-shell)        INSTALL_SHELL="none" ;;
        --shell=zsh)       INSTALL_SHELL="zsh" ;;
        --shell=bash)      INSTALL_SHELL="bash" ;;
        --shell=both)      INSTALL_SHELL="both" ;;
        --shell=auto)      INSTALL_SHELL="auto" ;;
        -h|--help)         sed -n '2,16p' "$0"; exit 0 ;;
        *)                 echo "Unknown arg: $arg" >&2; exit 2 ;;
    esac
done

# --- pretty printing -------------------------------------------------------
c_red()    { printf '\033[31m%s\033[0m' "$*"; }
c_green()  { printf '\033[32m%s\033[0m' "$*"; }
c_yellow() { printf '\033[33m%s\033[0m' "$*"; }
c_bold()   { printf '\033[1m%s\033[0m'  "$*"; }
say()      { printf '%s %s\n' "$(c_bold '==>')" "$*"; }
ok()       { printf '%s %s\n' "$(c_green '  ✓')" "$*"; }
warn()     { printf '%s %s\n' "$(c_yellow '  !')" "$*" >&2; }
die()      { printf '%s %s\n' "$(c_red '  ✗')" "$*" >&2; exit 1; }

# --- sanity ---------------------------------------------------------------
say "firejail-agents installer"
command -v firejail >/dev/null 2>&1 || die "firejail not installed (apt/dnf/pacman install firejail)"
ok "firejail $(firejail --version 2>/dev/null | head -n1 | awk '{print $3}')"

PROFILE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/firejail"
mkdir -p "$PROFILE_DIR"
ok "profile dir: $PROFILE_DIR"

# --- copy/update profiles -------------------------------------------------
say "Installing / updating profiles"
PROFILES=(code-agent.profile amp.profile copilot.profile claude.profile gemini.profile aider.profile)
PROFILES_DIR="$SCRIPT_DIR/profiles"
[ -d "$PROFILES_DIR" ] || die "missing profiles/ directory"
for p in "${PROFILES[@]}"; do
    [ -f "$PROFILES_DIR/$p" ] || die "missing source: profiles/$p"
    if [ -f "$PROFILE_DIR/$p" ] && cmp -s "$PROFILES_DIR/$p" "$PROFILE_DIR/$p"; then
        ok "$p (unchanged)"
    else
        if [ -f "$PROFILE_DIR/$p" ] && [ ! -f "$PROFILE_DIR/$p.bak" ]; then
            cp "$PROFILE_DIR/$p" "$PROFILE_DIR/$p.bak"
            warn "$p existed → backed up to $p.bak (one-time)"
        fi
        cp "$PROFILES_DIR/$p" "$PROFILE_DIR/$p"
        if [ -f "$PROFILE_DIR/$p.bak" ]; then
            ok "$p updated"
        else
            ok "$p installed"
        fi
    fi
done

# --- install AGENTS.md notice for in-jail agents --------------------------
say "Installing in-jail AGENTS.md notice"
AGENTS_SRC_DIR="$SCRIPT_DIR/agents"
AGENTS_DST_DIR="$HOME/.agents/firejail"
[ -f "$AGENTS_SRC_DIR/AGENTS.md" ] || die "missing source: agents/AGENTS.md"
mkdir -p "$AGENTS_DST_DIR"
if [ -f "$AGENTS_DST_DIR/AGENTS.md" ] && cmp -s "$AGENTS_SRC_DIR/AGENTS.md" "$AGENTS_DST_DIR/AGENTS.md"; then
    ok "AGENTS.md (unchanged) at $AGENTS_DST_DIR/AGENTS.md"
else
    cp "$AGENTS_SRC_DIR/AGENTS.md" "$AGENTS_DST_DIR/AGENTS.md"
    ok "AGENTS.md installed at $AGENTS_DST_DIR/AGENTS.md"
fi

# --- validate profile parses ----------------------------------------------
say "Validating profile syntax"
if firejail --quiet --profile="$PROFILE_DIR/amp.profile" /bin/true >/dev/null 2>&1; then
    ok "amp.profile parses"
else
    warn "amp.profile failed to parse — run: firejail --profile=$PROFILE_DIR/amp.profile /bin/true"
fi

# --- shell wrappers -------------------------------------------------------
SHELL_DIR="$SCRIPT_DIR/shell"
ZSH_SNIPPET="$SHELL_DIR/zshrc-snippet.sh"
BASH_SNIPPET="$SHELL_DIR/bashrc-snippet.sh"
[ -d "$SHELL_DIR" ]    || die "missing shell/ directory"
[ -f "$ZSH_SNIPPET" ]  || die "missing shell/zshrc-snippet.sh"
[ -f "$BASH_SNIPPET" ] || die "missing shell/bashrc-snippet.sh"

BEGIN='# ▰▱▰▱▰  firejail-agents: BEGIN  ▰▱▰▱▰'
END='# ▰▱▰▱▰  firejail-agents: END  ▰▱▰▱▰'

# Replace the BEGIN..END block in $rc with the contents of $snippet, or
# append if no block exists. Always idempotent.
inject_into_rc() {
    local rc="$1" snippet="$2" name="$3"
    if [ ! -e "$rc" ]; then
        warn "$name rc ($rc) not found, creating it"
        : > "$rc"
    fi
    if grep -Fq "$BEGIN" "$rc"; then
        # In-place update: cut existing block, splice new one.
        local tmp; tmp="$(mktemp)"
        awk -v B="$BEGIN" -v E="$END" -v F="$snippet" '
            BEGIN  { skip = 0 }
            $0 == B { skip = 1; while ((getline line < F) > 0) print line; close(F); next }
            $0 == E { skip = 0; next }
            skip == 0 { print }
        ' "$rc" > "$tmp"
        # Trim trailing blank lines, append a single newline.
        awk 'NR==FNR{lines[NR]=$0; n=NR; next} END{
            last=n; while (last>0 && lines[last]=="") last--;
            for (i=1;i<=last;i++) print lines[i];
        }' "$tmp" "$tmp" > "$rc"
        rm -f "$tmp"
        ok "$name: snippet updated in $rc"
    else
        {
            printf '\n\n# Added by caged install.sh on %s\n' \
                   "$(date -Iseconds 2>/dev/null || date)"
            cat "$snippet"
        } >> "$rc"
        ok "$name: snippet appended to $rc"
    fi
}

detect_shell() {
    case "$(basename -- "${SHELL:-}")" in
        zsh)  echo "zsh"  ;;
        bash) echo "bash" ;;
        *)
            if command -v zsh >/dev/null 2>&1 && [ -f "$HOME/.zshrc" ]; then
                echo "zsh"
            elif [ -f "$HOME/.bashrc" ] || command -v bash >/dev/null 2>&1; then
                echo "bash"
            else
                echo "none"
            fi
            ;;
    esac
}

if [ "$INSTALL_SHELL" = "auto" ]; then
    INSTALL_SHELL="$(detect_shell)"
    say "Detected shell: $INSTALL_SHELL (\$SHELL=${SHELL:-unset})"
fi

case "$INSTALL_SHELL" in
    none)
        say "Skipping shell wrapper install"
        echo "    Source one of these manually:"
        echo "      $ZSH_SNIPPET"
        echo "      $BASH_SNIPPET"
        ;;
    zsh)   say "Installing/updating zsh wrappers";  inject_into_rc "$HOME/.zshrc"  "$ZSH_SNIPPET"  "zsh" ;;
    bash)  say "Installing/updating bash wrappers"; inject_into_rc "$HOME/.bashrc" "$BASH_SNIPPET" "bash" ;;
    both)
        say "Installing/updating zsh + bash wrappers"
        inject_into_rc "$HOME/.zshrc"  "$ZSH_SNIPPET"  "zsh"
        inject_into_rc "$HOME/.bashrc" "$BASH_SNIPPET" "bash"
        ;;
    *)     die "unknown shell: $INSTALL_SHELL" ;;
esac

echo
say "Done. Open a new shell, then:"
cat <<'EOF'

      cd ~/some/project
      amp           # confined to ~/some/project + dev toolchains
      copilot       # same
      claude        # same
      gemini        # same
      aider         # same
      nojail amp    # escape hatch (no sandbox)

  Customise via ~/.config/firejail/<tool>.local files (see README.md).

EOF

# firejail-agents

Firejail profiles + shell wrappers that confine agentic coding helpers (Amp,
Copilot CLI, Claude Code, Gemini CLI, Aider, …) so they can only read and
write the directory you launched them from, plus the language toolchains
they legitimately need.

**License: AGPL-3.0** — See [LICENSE](LICENSE)

## What's protected

The agent **cannot** see (or exfiltrate via "please run this curl…"):
- `~/.ssh`, `~/.gnupg`, `~/.password-store`
- Cloud creds: `~/.aws`, `~/.azure`, `~/.kube`, `~/.config/gh`
- Crypto wallets: Electrum, Bitcoin, Ethereum, Exodus, Ledger, Trezor…
- Browser profiles (Firefox, Chrome, Brave, Vivaldi, Edge, Opera…)
- Chat/mail apps (Discord, Slack, Signal, Element, Telegram, Thunderbird…)
- Token files: `.npmrc`, `.pypirc`, `.netrc`, `.git-credentials`,
  `cargo/credentials.toml`, `.docker/config.json`, `m2/settings.xml`, …
- Anything else under `$HOME` that isn't on the dev allow-list

The agent **can** see (so it can actually do its job):
- `$PWD` — the directory you ran it in (only that subtree, not its parents)
- The agent's own config (`~/.amp`, `~/.config/copilot`, …)
- Toolchains: pyenv, volta, nvm, fnm, cargo/rustup, go/gvm, gradle/maven/sbt,
  bun, deno, ghcup, sdkman/jenv, rbenv/rvm, composer, terraform, ansible,
  helm, julia, opam, …
- Caches (`~/.cache`, `~/.npm`, `~/.local/share`, …) so installs work
- `~/.gitconfig` / `~/.editorconfig` / `.vimrc` — **read-only**
- Host-executed shim/bin trees (`~/.volta/bin`, `~/.cargo/bin`, `~/.gvm/*`,
  `~/.lmstudio/bin`, editor config dirs, Amp launcher/config) — **read-only**
- Agent config homes (`~/.amp`, `~/.claude`, `~/.gemini`, `~/.copilot`, …)
  are read-only by default (explicit writable state carve-outs only)
- High-risk executable cache subtrees (`~/.cache/yarn`, `~/.cache/pnpm`,
  `~/.cache/pip`, …) — **read-only**
- DNS + outbound network (so package installs and API calls work)

It also: drops all caps, blocks new privileges, applies seccomp, no root,
private `/tmp`, private `/dev`, no sound/video/dbus, no input devices.

## Install

**Quick start:**
```sh
git clone https://github.com/morawskidotmy/firejail-agents /tmp/firejail-agents && bash /tmp/firejail-agents/install.sh && rm -rf /tmp/firejail-agents
```

**Or step by step:**
```sh
bash install.sh           # auto-detect zsh/bash, install everything
bash install.sh --no-shell      # profiles only
bash install.sh --shell=both    # patch both ~/.zshrc and ~/.bashrc
```

The installer is idempotent — re-running won't double up. Existing
profiles are backed up to `<name>.profile.bak` on first overwrite.

Prerequisite: `firejail` (e.g. `apt install firejail`,
`dnf install firejail`, `pacman -S firejail`).

## Use

```sh
cd ~/Documents/myproject
amp                # jailed: only sees myproject/ + toolchains, no creds
copilot            # same
claude             # same
gemini             # same
aider              # same

nojail amp …       # escape hatch: run unsandboxed
```

## Customise

Drop `<name>.local` files next to the profiles to extend without editing
the originals:

- `~/.config/firejail/code-agent.local` — applied to all agents
- `~/.config/firejail/amp.local` — applied to Amp only
- (likewise `copilot.local`, `claude.local`, `gemini.local`, `aider.local`)

For an air-gapped run, put `net none` in `code-agent.local`.

## Podman / containers

Local rootless podman cannot run inside the jail — `noroot` + `nonewprivs`
+ `seccomp` block the user-namespace setup it requires. Instead the agent
talks to a `podman system service` running on the **host** via the
rootless API socket.

Enable it once:

```sh
systemctl --user enable --now podman.socket
```

The shell wrappers detect `/run/user/$UID/podman/podman.sock` and inject
`CONTAINER_HOST=unix://…` automatically, so `podman ps`, `podman build`,
`run-podman.sh`, etc. just work from inside the jail. Builds and
containers run on the host (outside the sandbox); only the client is
confined.

## Files

- `code-agent.profile` — shared base profile (whitelist mode, hardening,
  toolchain allow-list, credential blacklists)
- `amp.profile`, `copilot.profile`, `claude.profile`, `gemini.profile`,
  `aider.profile` — per-tool wrappers that whitelist that tool's config
  dir then `include code-agent.profile`
- `zshrc-snippet.sh` — copy/paste into `~/.zshrc`; defines `amp`,
  `copilot`, `claude`, `gemini`, `aider`, and `nojail` shell functions
  that inject `--whitelist="$PWD"`

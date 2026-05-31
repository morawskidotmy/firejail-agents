<div align="center">

# firejail-agents

*Run AI coding agents like they're untrusted — because they are.*

[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue.svg?style=flat-square)](LICENSE)
[![Firejail](https://img.shields.io/badge/sandbox-firejail-orange.svg?style=flat-square)](https://firejail.wordpress.com/)
[![Shells](https://img.shields.io/badge/shell-bash%20%7C%20zsh-89e051.svg?style=flat-square)](#install)
[![Topics](https://img.shields.io/badge/topics-sandbox%20·%20agents%20·%20devtools-555.svg?style=flat-square)](https://github.com/morawskidotmy/firejail-agents)

[Why](#why) • [How it works](#how-it-works) • [Install](#install) • [Use](#use) • [Add your own agent](#add-your-own-agent) • [Customise](#customise)

</div>

Firejail profiles and shell wrappers that confine **agentic coding helpers**
(Amp, Copilot CLI, Claude Code, Gemini CLI, Aider, …) so an agent can read
and write *only* the directory you launched it from, plus the language
toolchains it legitimately needs. SSH keys, cloud creds, browser profiles,
crypto wallets, and sibling projects all become invisible to the agent —
without breaking `git`, `npm`, `pip`, `cargo`, or `podman`.

```sh
cd ~/Documents/myproject
amp                # jailed: sees myproject/ + toolchains, nothing else
nojail amp …       # escape hatch: run unsandboxed
```

## Why

You let an LLM run shell commands in your home directory. It can `cat
~/.ssh/id_ed25519`. It can `grep -r token ~/.aws`. It can read your
Firefox cookies, Slack tokens, and seed phrases. Today's agent might be
fine. Tomorrow's prompt injection from a random GitHub issue may not be.

This project answers the smallest useful version of *"can I limit the
blast radius?"* — without containers, without VMs, with one `apt install`
and one `install.sh`.

## How it works

```diagram
╭────────────────╮     ╭──────────────────────────╮     ╭─────────────────╮
│  you type      │     │  shell function          │     │  firejail jail  │
│  `amp` in zsh  │────▶│  amp() { firejail        │────▶│  sees only:     │
│                │     │    --profile=amp         │     │  • $PWD         │
│                │     │    --whitelist=$PWD …}   │     │  • ~/.amp (ro)  │
╰────────────────╯     ╰──────────────────────────╯     │  • toolchains   │
                                                        │  • DNS + net    │
                                                        ╰─────────────────╯
```

- **Profiles** (`~/.config/firejail/<agent>.profile`) declare what's
  visible, what's read-only, and what's blocked. Each per-tool profile
  inherits a shared `code-agent.profile` base.
- **Shell snippet** (in your `~/.bashrc` or `~/.zshrc`) auto-discovers
  installed profiles at shell startup and wraps every matching command
  with `firejail --whitelist="$PWD" …`.
- **In-jail notice** (`FIREJAIL.md`) is symlinked into `$PWD` on launch,
  so the agent reads it on first run and knows what's blocked — no
  thrashing on "Permission denied".

### What's protected

The agent **cannot** see (or exfiltrate via *"please run this curl…"*):

- `~/.ssh`, `~/.gnupg`, `~/.password-store`
- Cloud creds: `~/.aws`, `~/.azure`, `~/.kube`, `~/.config/gh`,
  `~/.config/gcloud`, `~/.docker/config.json`
- Browser profiles: Firefox, Chrome, Brave, Vivaldi, Edge, Opera, …
- Chat / mail apps: Discord, Slack, Signal, Element, Telegram,
  Thunderbird, …
- Crypto wallets: Electrum, Bitcoin, Ethereum, Exodus, Ledger, Trezor, …
- Token files: `.npmrc`, `.pypirc`, `.netrc`, `.git-credentials`,
  `cargo/credentials.toml`, `.docker/config.json`, `m2/settings.xml`, …
- Anything else under `$HOME` that isn't on the dev allow-list
- **Sibling project directories** — `cd ..` doesn't escape the jail

It also drops all caps, blocks new privileges, applies seccomp, no root,
private `/tmp`, private `/dev`, no sound/video/dbus, no input devices.

### What's still available

So the agent can actually do its job:

- `$PWD` (read-write) and its entire subtree
- The agent's own config dir (mostly read-only; a writable state carve-out
  per tool)
- Language toolchains: pyenv/uv/pipx, volta/nvm/fnm, npm/pnpm/yarn/bun/deno,
  cargo/rustup, go/gvm, gradle/maven/sbt, ghcup, sdkman/jenv, rbenv/rvm,
  composer, terraform/ansible/helm, julia, opam, and friends
- `~/.gitconfig`, `~/.editorconfig`, `.vimrc` — **read-only**
- Shim/bin trees (`~/.volta/bin`, `~/.cargo/bin`, `~/.local/bin`, …) —
  **read-only** so the agent can run them but can't replace them
- DNS + outbound network for package installs and API calls

## Install

> [!IMPORTANT]
> Requires `firejail` on the host: `apt install firejail` /
> `dnf install firejail` / `pacman -S firejail`.

**One-liner:**

```sh
git clone https://github.com/morawskidotmy/firejail-agents /tmp/firejail-agents \
    && bash /tmp/firejail-agents/install.sh \
    && rm -rf /tmp/firejail-agents
```

**Or step by step:**

```sh
bash install.sh                # auto-detect zsh/bash, install everything
bash install.sh --no-shell     # profiles only, skip rc edits
bash install.sh --shell=both   # patch both ~/.zshrc and ~/.bashrc
```

The installer is idempotent — re-running won't double up. Existing
profiles are backed up to `<name>.profile.bak` on first overwrite. At the
end it prints a per-agent summary showing which commands will be
sandboxed in your next shell, and warns about profiles whose binary isn't
on `$PATH`.

### PATH requirement

The shell snippet wraps a command **only** when both of these are true:

1. a profile exists at `~/.config/firejail/<name>.profile`, **and**
2. `command -v <name>` finds an executable on `$PATH`.

Most install methods put the agent on `$PATH` automatically. A few don't:

| Agent     | Common install location  | Usually on `$PATH`?   |
|-----------|--------------------------|-----------------------|
| `amp`     | `~/.amp/bin/amp`         | **no**                |
| `copilot` | `~/.local/bin/copilot`   | yes                   |
| `claude`  | `~/.local/bin/claude`    | yes                   |
| `gemini`  | `~/.volta/bin/gemini`    | yes (if volta set up) |
| `aider`   | wherever `pipx`/`pip` puts it | yes              |

> [!TIP]
> If `install.sh` reports an agent as missing, symlink it into a directory
> that's already on your `$PATH`:
> ```sh
> mkdir -p ~/.local/bin
> ln -s ~/.amp/bin/amp       ~/.local/bin/amp
> ln -s ~/.volta/bin/gemini  ~/.local/bin/gemini
> ```
> Or extend `$PATH` in `~/.zshenv` / `~/.bash_profile`:
> ```sh
> export PATH="$HOME/.amp/bin:$HOME/.volta/bin:$PATH"
> ```
> Open a fresh shell, run `command -v amp` (must print a path), and the
> wrapper appears automatically.

## Use

```sh
cd ~/Documents/myproject
amp                # jailed
copilot            # jailed
claude             # jailed
gemini             # jailed
aider              # jailed

nojail amp …       # escape hatch: run unsandboxed for one invocation
```

Peek inside the jail to see what an agent actually has access to:

```sh
firejail --profile=amp --whitelist="$PWD" ls ~
```

## Add your own agent

The setup is fully profile-driven. To wire up a new agent (say
`my-agent`):

1. **Write a profile** in `profiles/my-agent.profile`:

   ```firejail
   # Firejail profile for my-agent.
   include my-agent.local

   # Whitelist (and freeze) the agent's own config home.
   whitelist  ${HOME}/.my-agent
   whitelist  ${HOME}/.config/my-agent
   read-only  ${HOME}/.my-agent
   read-only  ${HOME}/.config/my-agent

   include code-agent.profile
   ```

2. **Re-run** `bash install.sh`. The installer auto-discovers every
   `profiles/*.profile`, so no installer edit is needed.

3. **Make sure `my-agent` is on `$PATH`** (`command -v my-agent`). If
   not, see [PATH requirement](#path-requirement).

4. **Open a new shell**. `my-agent` is now sandboxed automatically.

> [!NOTE]
> To temporarily disable jailing for one agent without uninstalling, just
> delete its profile: `rm ~/.config/firejail/aider.profile`. The next
> shell will skip wrapping `aider` and fall through to the real binary.
> Re-running `install.sh` puts the profile back.

## Customise

Drop `<name>.local` files next to the profiles to extend without editing
the originals:

- `~/.config/firejail/code-agent.local` — applied to all agents
- `~/.config/firejail/amp.local` — applied to Amp only
- (likewise `copilot.local`, `claude.local`, `gemini.local`,
  `aider.local`)

For an air-gapped run, put `net none` in `code-agent.local`.

## Podman / containers

> [!WARNING]
> Local rootless `podman` cannot run *inside* the jail — `noroot` +
> `nonewprivs` + `seccomp` block the user-namespace setup it requires.

Instead the agent talks to a `podman system service` running on the
**host** via the rootless API socket.

Enable it once:

```sh
systemctl --user enable --now podman.socket
```

The shell wrappers detect `/run/user/$UID/podman/podman.sock` and inject
`CONTAINER_HOST=unix://…` automatically, so `podman ps`, `podman build`,
`podman run`, etc. just work from inside the jail. Builds and containers
run on the host (outside the sandbox); only the client is confined.

## Uninstall

There's no dedicated uninstaller — everything the installer touches is
easy to remove by hand:

```sh
# 1. Remove the profiles.
rm -f ~/.config/firejail/{code-agent,amp,copilot,claude,gemini,aider}.profile
rm -f ~/.config/firejail/{code-agent,amp,copilot,claude,gemini,aider}.profile.bak

# 2. Remove the in-jail FIREJAIL.md notice.
rm -rf ~/.agents/firejail

# 3. Strip the snippet block from your rc(s).
sed -i '/▰▱▰▱▰  firejail-agents: BEGIN/,/▰▱▰▱▰  firejail-agents: END/d' \
    ~/.zshrc ~/.bashrc 2>/dev/null || true
```

## Project layout

```diagram
firejail-agents/
├── install.sh              ← idempotent installer (auto-discovers profiles)
├── profiles/
│   ├── code-agent.profile  ← shared base: hardening + toolchain allow-list
│   ├── amp.profile         ← per-tool: whitelist tool config, then `include`
│   ├── copilot.profile         the base
│   ├── claude.profile
│   ├── gemini.profile
│   └── aider.profile
├── shell/
│   ├── bashrc-snippet.sh   ← scans ~/.config/firejail/*.profile and wraps
│   └── zshrc-snippet.sh      every profile whose name is on $PATH
└── agents/
    └── FIREJAIL.md         ← "you are in a firejail" notice; symlinked into
                              $PWD on agent launch, removed on exit
```

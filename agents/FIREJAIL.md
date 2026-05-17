# YOU ARE RUNNING INSIDE FIREJAIL

This process is confined by **firejail-agents**
(https://github.com/morawskidotmy/firejail-agents). Read this before you
plan filesystem, network, or shell actions — many "normal" operations
will fail with confusing errors (`Permission denied`, `No such file or
directory`, `Operation not permitted`) **not because the code is wrong,
but because the sandbox blocked them**.

If you hit one of those errors, check this file before retrying.

---

## What you CAN do

- **Read & write the current working directory** (`$PWD`) and its
  entire subtree. This is the project you were launched in.
- **Read your own agent config**: `~/.amp`, `~/.config/copilot`,
  `~/.claude`, `~/.gemini`, `~/.config/aider`, etc. (some carved-out
  state subpaths are writable; most of the config home is read-only).
- **Use language toolchains**: pyenv, uv, pipx, volta, nvm, fnm, npm,
  pnpm, yarn, bun, deno, cargo/rustup, go/gvm, gradle/maven/sbt, ghcup,
  sdkman, rbenv/rvm, composer, terraform, ansible, helm, julia, opam,
  and their caches in `~/.cache`, `~/.local/share`, `~/.npm`, …
  (some executable cache subtrees like `~/.cache/yarn`, `~/.cache/pnpm`,
  `~/.cache/pip` are **read-only** — install with the package manager,
  don't rewrite the cache by hand).
- **Read** (only) `~/.gitconfig`, `~/.editorconfig`, `.vimrc`, and
  host-installed shim/bin trees (`~/.volta/bin`, `~/.cargo/bin`, …).
- **Network**: DNS + outbound TCP/UDP work, so `git fetch`, `npm
  install`, `pip install`, API calls, etc. all work normally.
- **Talk to host podman** via the rootless socket at
  `$CONTAINER_HOST` (if exported). `podman ps`, `podman build`,
  `podman run` work — but the containers run **on the host**, outside
  this sandbox.

## What you CANNOT do (and must not try to work around)

- **You cannot see anything else under `$HOME`.** Specifically blocked:
  - SSH / GPG: `~/.ssh`, `~/.gnupg`, `~/.password-store`
  - Cloud creds: `~/.aws`, `~/.azure`, `~/.kube`, `~/.config/gh`,
    `~/.config/gcloud`, `~/.docker/config.json`
  - Browser profiles: Firefox, Chrome, Brave, Vivaldi, Edge, Opera, …
  - Chat / mail: Discord, Slack, Signal, Element, Telegram,
    Thunderbird, …
  - Crypto wallets: Electrum, Bitcoin, Ethereum, Exodus, Ledger,
    Trezor, …
  - Token files: `.npmrc` (auth), `.pypirc`, `.netrc`,
    `.git-credentials`, `cargo/credentials.toml`, `m2/settings.xml`, …
  - Anything else under `$HOME` not on the dev allow-list above.
  - **Sibling project directories**: you cannot `cd ..` or read
    `~/Documents/other-project`. Only `$PWD` and its subtree are
    visible.
- **You cannot escalate privileges**: `sudo`, `su`, `setuid` binaries,
  `mount`, `unshare`, user namespaces, `ptrace` — all blocked.
  - `noroot`, `nonewprivs`, seccomp, all caps dropped.
  - Rootless `podman`/`buildah`/`docker` **inside** the jail will fail
    (user namespaces blocked). Use the host podman socket via
    `$CONTAINER_HOST` instead — it's already wired up.
- **No `/tmp` sharing with the host**: `/tmp` is a private tmpfs. Files
  you put there vanish when the jail exits and are invisible to other
  processes.
- **No `/dev` access** beyond a minimal whitelist: no sound, no video,
  no input devices, no `/dev/kvm`, no raw disks.
- **No D-Bus, no X11/Wayland access** (unless the profile carved it
  out). GUI apps will not launch.
- **You cannot install global packages** that need root (`apt`, `dnf`,
  `pacman`, `brew install` to system prefixes). Use per-project /
  per-user managers (`uv`, `pipx`, `npm i` in the project, `cargo
  install`, `volta install`, …).

## How to behave well in here

1. **Don't pretend a missing credential is a bug to fix.** If a tool
   asks for `~/.aws/credentials` and it isn't there, that's by design —
   ask the user to run it outside the jail (`nojail <tool>`), or to
   pass credentials via env vars that they paste in.
2. **Don't try to read files outside `$PWD`.** Stop and tell the user
   what you'd need; don't loop on `Permission denied`.
3. **Don't try to `sudo` anything.** It will fail. Solve the problem
   user-locally (venv, project-local install, `uv tool install`,
   `cargo install --root .`, …).
4. **Prefer `$PWD`-local state** over `/tmp` for anything you want to
   survive the run. `/tmp` is wiped when the jail exits.
5. **If you need to escape**, tell the user to re-run the command as
   `nojail amp …` / `nojail copilot …` / etc. Don't try to break out
   yourself.
6. **This `FIREJAIL.md` is a symlink** that the wrapper drops into
   `$PWD` at launch and removes at exit. Don't commit it. Don't delete
   it — but if you see it appear/disappear between runs, that's normal.

## Quick diagnostic

If you're confused about what is or isn't visible, try:

```sh
ls -la /            # see the jailed root
ls -la "$HOME"      # see only the carve-outs
echo "$CONTAINER_HOST"   # host podman socket, if exported
```

That's the truth of your environment. Plan accordingly.

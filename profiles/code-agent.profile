# Firejail profile for agentic coding assistants (amp, copilot, claude, …)
#
# WHITELIST mode: by default the agent sees almost nothing in $HOME.
# The shell wrapper (~/.zshrc functions) injects `--whitelist="$PWD"` so the
# agent can only touch the directory the user invoked it from.
#
# Per-tool wrappers (amp.profile, copilot.profile, …) `include` this file
# AFTER whitelisting their own config dir.

include code-agent.local

### --- Override system disable-* includes that would hide dev dirs --------
# disable-programs.inc / disable-common.inc blacklist ~/.cargo, ~/.gradle,
# ~/.rustup, ~/.gem etc. by default. Tell firejail not to honour those
# blacklists for the toolchain dirs the agent legitimately needs.
noblacklist ${HOME}/.cargo
noblacklist ${HOME}/.rustup
noblacklist ${HOME}/.gradle
noblacklist ${HOME}/.m2
noblacklist ${HOME}/.gem
noblacklist ${HOME}/.bundle
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.pnpm
noblacklist ${HOME}/.yarn
noblacklist ${HOME}/.config/yarn
noblacklist ${HOME}/.bun
noblacklist ${HOME}/.deno
noblacklist ${HOME}/.nvm
noblacklist ${HOME}/.volta
noblacklist ${HOME}/.fnm
noblacklist ${HOME}/.node-gyp
noblacklist ${HOME}/.electron-gyp
noblacklist ${HOME}/.expo
noblacklist ${HOME}/.pyenv
noblacklist ${HOME}/.venv
noblacklist ${HOME}/.virtualenvs
noblacklist ${HOME}/.poetry
noblacklist ${HOME}/.config/pypoetry
noblacklist ${HOME}/.config/uv
noblacklist ${HOME}/.config/pip
noblacklist ${HOME}/.go
noblacklist ${HOME}/go
noblacklist ${HOME}/.gvm
noblacklist ${HOME}/.sbt
noblacklist ${HOME}/.ivy2
noblacklist ${HOME}/.java
noblacklist ${HOME}/.sdkman
noblacklist ${HOME}/.jenv
noblacklist ${HOME}/.rbenv
noblacklist ${HOME}/.rvm
noblacklist ${HOME}/.composer
noblacklist ${HOME}/.config/composer
noblacklist ${HOME}/.ghcup
noblacklist ${HOME}/.cabal
noblacklist ${HOME}/.stack
noblacklist ${HOME}/.opam
noblacklist ${HOME}/.julia
noblacklist ${HOME}/.nimble
noblacklist ${HOME}/.zvm
noblacklist ${HOME}/.terraform.d
noblacklist ${HOME}/.config/helm
noblacklist ${HOME}/.ansible
noblacklist ${HOME}/.vscode-oss
noblacklist ${HOME}/.cursor
noblacklist ${HOME}/.config/Code
noblacklist ${HOME}/.config/Cursor
noblacklist ${HOME}/.config/nvim
noblacklist ${HOME}/.lmstudio
noblacklist ${HOME}/.ollama
noblacklist ${HOME}/.cache
noblacklist ${HOME}/.local

### --- Dev config (mostly read-only) --------------------------------------
whitelist ${HOME}/.gitconfig
whitelist ${HOME}/.config/git
whitelist ${HOME}/.gitignore_global
whitelist ${HOME}/.editorconfig
whitelist ${HOME}/.tool-versions
whitelist ${HOME}/.python-version
whitelist ${HOME}/.node-version
whitelist ${HOME}/.ruby-version
whitelist ${HOME}/.nvmrc
whitelist ${HOME}/.config/nvim
whitelist ${HOME}/.vimrc
whitelist ${HOME}/.vim
whitelist ${HOME}/.nanorc

### --- Caches & user-installed binaries ------------------------------------
whitelist ${HOME}/.cache
whitelist ${HOME}/.local/bin
whitelist ${HOME}/.local/lib
whitelist ${HOME}/.local/share
whitelist ${HOME}/.local/state
whitelist ${HOME}/.local/include

### --- Language toolchains & version managers -----------------------------
# JS / TS
whitelist ${HOME}/.npm
whitelist ${HOME}/.pnpm
whitelist ${HOME}/.pnpm-store
whitelist ${HOME}/.yarn
whitelist ${HOME}/.config/yarn
whitelist ${HOME}/.bun
whitelist ${HOME}/.deno
whitelist ${HOME}/.nvm
whitelist ${HOME}/.volta
whitelist ${HOME}/.fnm
whitelist ${HOME}/.node-gyp
whitelist ${HOME}/.electron-gyp
whitelist ${HOME}/.expo
# Rust
whitelist ${HOME}/.cargo
whitelist ${HOME}/.rustup
# Python
whitelist ${HOME}/.pyenv
whitelist ${HOME}/.venv
whitelist ${HOME}/.virtualenvs
whitelist ${HOME}/.config/pypoetry
whitelist ${HOME}/.config/uv
whitelist ${HOME}/.poetry
whitelist ${HOME}/.config/pip
# Go
whitelist ${HOME}/.go
whitelist ${HOME}/go
whitelist ${HOME}/.gvm
# Java / JVM
whitelist ${HOME}/.gradle
whitelist ${HOME}/.m2
whitelist ${HOME}/.sbt
whitelist ${HOME}/.ivy2
whitelist ${HOME}/.java
whitelist ${HOME}/.sdkman
whitelist ${HOME}/.jenv
# Ruby
whitelist ${HOME}/.gem
whitelist ${HOME}/.rbenv
whitelist ${HOME}/.rvm
whitelist ${HOME}/.bundle
# PHP / Composer
whitelist ${HOME}/.composer
whitelist ${HOME}/.config/composer
# Haskell / OCaml / others
whitelist ${HOME}/.ghcup
whitelist ${HOME}/.cabal
whitelist ${HOME}/.stack
whitelist ${HOME}/.opam
whitelist ${HOME}/.julia
whitelist ${HOME}/.nimble
whitelist ${HOME}/.zvm
whitelist ${HOME}/.elixir-ls
# DevOps tooling
whitelist ${HOME}/.terraform.d
whitelist ${HOME}/.config/helm
whitelist ${HOME}/.ansible
# Editors / IDEs (config only — workspaces are still confined to PWD)
whitelist ${HOME}/.vscode-oss
whitelist ${HOME}/.cursor
whitelist ${HOME}/.config/Code
whitelist ${HOME}/.config/Cursor
# Local LLM tooling
whitelist ${HOME}/.lmstudio
whitelist ${HOME}/.lmstudio-home-pointer
whitelist ${HOME}/.ollama

### --- Read-only: prevent the agent rewriting your dev identity -----------
read-only ${HOME}/.gitconfig
read-only ${HOME}/.config/git
read-only ${HOME}/.gitignore_global
read-only ${HOME}/.editorconfig
read-only ${HOME}/.tool-versions
read-only ${HOME}/.python-version
read-only ${HOME}/.node-version
read-only ${HOME}/.ruby-version
read-only ${HOME}/.nvmrc
read-only ${HOME}/.vimrc
read-only ${HOME}/.nanorc
read-only ${HOME}/.config/nvim

### --- Read-only: bin/shim trees the USER runs OUTSIDE the jail -----------
# A confined agent must never be able to overwrite an executable that the
# host user later launches with full privileges. We keep these dirs visible
# (so the agent can *use* the toolchain) but prevent it from replacing the
# binaries / shims / trampolines living inside them.
#
# If you legitimately need to `npm i -g`, `cargo install`, etc. from inside
# an agent session, run it with `nojail` instead.
read-only ${HOME}/.local/bin
read-only ${HOME}/.local/lib
read-only ${HOME}/.local/share/applications
# JS / TS
read-only ${HOME}/.npm/_npx
read-only ${HOME}/.volta
read-only ${HOME}/.volta/bin
read-only ${HOME}/.volta/tools
read-only ${HOME}/.bun/bin
read-only ${HOME}/.deno/bin
read-only ${HOME}/.nvm
read-only ${HOME}/.nvm/versions
read-only ${HOME}/.fnm
read-only ${HOME}/.fnm/node-versions
read-only ${HOME}/.fnm/aliases
read-only ${HOME}/.yarn/bin
read-only ${HOME}/.pnpm
read-only ${HOME}/.pnpm-store
# Rust
read-only ${HOME}/.cargo
read-only ${HOME}/.cargo/bin
read-only ${HOME}/.rustup/toolchains
# Python
read-only ${HOME}/.pyenv
read-only ${HOME}/.pyenv/shims
read-only ${HOME}/.pyenv/versions
read-only ${HOME}/.poetry/bin
# Go
read-only ${HOME}/.go/bin
read-only ${HOME}/go/bin
read-only ${HOME}/.gvm/bin
# Java / JVM
read-only ${HOME}/.sdkman
read-only ${HOME}/.sdkman/candidates
read-only ${HOME}/.jenv/shims
read-only ${HOME}/.jenv/versions
read-only ${HOME}/.gradle/bin
read-only ${HOME}/.java
# Ruby
read-only ${HOME}/.gem/bin
read-only ${HOME}/.rbenv
read-only ${HOME}/.rbenv/shims
read-only ${HOME}/.rbenv/versions
read-only ${HOME}/.rvm/bin
read-only ${HOME}/.rvm/rubies
# PHP / Composer
read-only ${HOME}/.composer/vendor/bin
read-only ${HOME}/.config/composer/vendor/bin
# Haskell / OCaml / others
read-only ${HOME}/.cabal/bin
read-only ${HOME}/.ghcup
read-only ${HOME}/.ghcup/bin
read-only ${HOME}/.opam
read-only ${HOME}/.julia/bin
read-only ${HOME}/.nimble/bin
read-only ${HOME}/.zvm/bin
read-only ${HOME}/.zvm/self

### --- Read-only: editor / IDE configs (extensions + tasks = code) --------
# tasks.json with `runOptions.runOn:"folderOpen"`, malicious extensions,
# settings.json hooks etc. all execute on the host outside the jail.
read-only ${HOME}/.vscode-oss
read-only ${HOME}/.cursor
read-only ${HOME}/.config/Code
read-only ${HOME}/.config/Cursor

### --- Read-only: cache trees with host-executed artifacts -----------------
# Keep general caches writable for day-to-day installs, but freeze cache
# subtrees that commonly hold executables, hooks, or wheels later run on host.
read-only ${HOME}/.cache/yarn
read-only ${HOME}/.cache/pnpm
read-only ${HOME}/.cache/pip
read-only ${HOME}/.cache/pypoetry
read-only ${HOME}/.cache/uv
read-only ${HOME}/.cache/node/corepack
read-only ${HOME}/.cache/bun
read-only ${HOME}/.cache/deno

### --- Belt-and-braces blacklists for credentials inside whitelisted dirs --
blacklist ${HOME}/.cache/mozilla
blacklist ${HOME}/.cache/firefox
blacklist ${HOME}/.cache/chromium
blacklist ${HOME}/.cache/google-chrome
blacklist ${HOME}/.cache/BraveSoftware
blacklist ${HOME}/.cache/keyring*
blacklist ${HOME}/.local/share/keyrings
blacklist ${HOME}/.local/share/gnome-keyring
blacklist ${HOME}/.cargo/credentials.toml
blacklist ${HOME}/.cargo/credentials
blacklist ${HOME}/.npmrc
blacklist ${HOME}/.pypirc
blacklist ${HOME}/.netrc
blacklist ${HOME}/.git-credentials
blacklist ${HOME}/.config/git/credentials
blacklist ${HOME}/.config/pip/pip.conf
blacklist ${HOME}/.config/pypoetry/auth.toml
blacklist ${HOME}/.config/uv/credentials.toml
blacklist ${HOME}/.gem/credentials
blacklist ${HOME}/.composer/auth.json
blacklist ${HOME}/.config/composer/auth.json
blacklist ${HOME}/.docker/config.json
blacklist ${HOME}/.m2/settings.xml
blacklist ${HOME}/.m2/settings-security.xml
blacklist ${HOME}/.gradle/gradle.properties
blacklist ${HOME}/.cabal/config

blacklist /run/user/*/wayland-*
blacklist /run/user/*/weston.sock
blacklist /run/user/*/pipewire-*
blacklist /run/user/*/.flatpak
blacklist /run/user/*/bus
blacklist ${HOME}/.local/share/pipewire
blacklist ${HOME}/.local/share/xdg-desktop-portal

include disable-common.inc
include disable-programs.inc

### --- Hardening ----------------------------------------------------------
caps.drop all
nonewprivs
noroot
seccomp
seccomp.block-secondary
protocol unix,inet,inet6,netlink

nosound
novideo
no3d
notv
nodvd
nou2f
noinput
nodbus

# --- Block GUI access (X11 + Wayland) -------------------------------------
rmenv DISPLAY
rmenv WAYLAND_DISPLAY
rmenv XAUTHORITY
rmenv XDG_SESSION_TYPE
blacklist /tmp/.X11-unix
blacklist /tmp/.ICE-unix
blacklist ${RUNUSER}/wayland-*
blacklist ${RUNUSER}/.mutter-Xwaylandauth.*
blacklist ${HOME}/.Xauthority
blacklist ${HOME}/.ICEauthority

disable-mnt
machine-id

private-dev
private-tmp

### --- Networking --------------------------------------------------------
# Agents need outbound for package installs / API calls. Override with
# `net none` in code-agent.local for an air-gapped run.
netfilter
dns 1.1.1.1
dns 9.9.9.9

private-etc alternatives,ca-certificates,crypto-policies,resolv.conf,hosts,host.conf,hostname,nsswitch.conf,localtime,timezone,ssl,pki,gai.conf,protocols,services,login.defs,passwd,group,shells,terminfo,fonts,gitconfig,gitattributes,profile,profile.d,bash.bashrc,zsh,inputrc,nanorc,vimrc,vim,xdg,java-*,maven,gradle

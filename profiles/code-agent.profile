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
noblacklist ${HOME}/.agents
noblacklist ${HOME}/.cache
noblacklist ${HOME}/.local
# Podman (rootless): config + local image/container store + runtime sockets.
noblacklist ${HOME}/.config/containers
noblacklist ${HOME}/.local/share/containers
noblacklist ${HOME}/.cache/containers
noblacklist /run/podman
noblacklist /run/user/*/podman
# Version managers
noblacklist ${HOME}/.asdf
noblacklist ${HOME}/.config/asdf
noblacklist ${HOME}/.config/mise
noblacklist ${HOME}/.local/share/mise
noblacklist ${HOME}/.local/state/mise
# Build / package systems
noblacklist ${HOME}/.bazel
noblacklist ${HOME}/.cache/bazel
noblacklist ${HOME}/.cache/bazelisk
noblacklist ${HOME}/.bazelisk
noblacklist ${HOME}/.cache/buck
noblacklist ${HOME}/.buck2
noblacklist ${HOME}/.cache/buck2
noblacklist ${HOME}/.cache/pants
noblacklist ${HOME}/.cache/pants.d
noblacklist ${HOME}/.conan
noblacklist ${HOME}/.conan2
noblacklist ${HOME}/.cmake
noblacklist ${HOME}/.vcpkg
noblacklist ${HOME}/.config/vcpkg
noblacklist ${HOME}/.cache/ccache
noblacklist ${HOME}/.ccache
noblacklist ${HOME}/.cache/sccache
noblacklist ${HOME}/.config/sccache
noblacklist ${HOME}/.cache/mold
# Python ecosystem (extra)
noblacklist ${HOME}/.local/pipx
noblacklist ${HOME}/.local/share/pipx
noblacklist ${HOME}/.local/state/pipx
noblacklist ${HOME}/.local/share/hatch
noblacklist ${HOME}/.local/share/pdm
noblacklist ${HOME}/.config/pdm
noblacklist ${HOME}/.rye
noblacklist ${HOME}/.tox
noblacklist ${HOME}/.cache/pre-commit
noblacklist ${HOME}/.cache/maturin
noblacklist ${HOME}/.conda
noblacklist ${HOME}/.config/conda
noblacklist ${HOME}/miniconda3
noblacklist ${HOME}/anaconda3
noblacklist ${HOME}/mambaforge
noblacklist ${HOME}/miniforge3
noblacklist ${HOME}/.pixi
# Erlang / Elixir
noblacklist ${HOME}/.mix
noblacklist ${HOME}/.hex
noblacklist ${HOME}/.config/rebar3
noblacklist ${HOME}/.cache/rebar3
noblacklist ${HOME}/.kerl
# Lua
noblacklist ${HOME}/.luarocks
noblacklist ${HOME}/.config/luarocks
noblacklist ${HOME}/.cache/luarocks
# R
noblacklist ${HOME}/.R
noblacklist ${HOME}/R
noblacklist ${HOME}/.Renviron
noblacklist ${HOME}/.Rprofile
noblacklist ${HOME}/.cache/R
# Lean / theorem provers
noblacklist ${HOME}/.elan
noblacklist ${HOME}/.cache/mathlib
# Swift
noblacklist ${HOME}/.swiftpm
noblacklist ${HOME}/.config/swiftpm
noblacklist ${HOME}/.cache/swift
# Clojure
noblacklist ${HOME}/.clojure
noblacklist ${HOME}/.config/clojure
noblacklist ${HOME}/.lein
noblacklist ${HOME}/.boot
noblacklist ${HOME}/.cpcache
noblacklist ${HOME}/.deps.clj
noblacklist ${HOME}/.gitlibs
noblacklist ${HOME}/.m2/repository
# Crystal / D / Nim / Zig / Gleam / Roc
noblacklist ${HOME}/.cache/crystal
noblacklist ${HOME}/.crystal
noblacklist ${HOME}/.dub
noblacklist ${HOME}/.cache/zig
noblacklist ${HOME}/.zig
noblacklist ${HOME}/.cache/gleam
noblacklist ${HOME}/.cache/roc
# Common Lisp / Scheme / Racket
noblacklist ${HOME}/.racket
noblacklist ${HOME}/.config/racket
noblacklist ${HOME}/.roswell
noblacklist ${HOME}/.quicklisp
noblacklist ${HOME}/.sbclrc
noblacklist ${HOME}/.cache/chicken-install
noblacklist ${HOME}/.chicken
# Wasm
noblacklist ${HOME}/.wasmer
noblacklist ${HOME}/.wasmtime
noblacklist ${HOME}/.wasmedge
# DevOps / k8s / IaC tooling
noblacklist ${HOME}/.docker
noblacklist ${HOME}/.skaffold
noblacklist ${HOME}/.tilt-dev
noblacklist ${HOME}/.config/k9s
noblacklist ${HOME}/.config/lazygit
noblacklist ${HOME}/.config/lazydocker
noblacklist ${HOME}/.config/gh-dash
noblacklist ${HOME}/.kustomize
noblacklist ${HOME}/.config/kustomize
noblacklist ${HOME}/.config/helmfile
noblacklist ${HOME}/.cache/helm
noblacklist ${HOME}/.cache/kubectl
noblacklist ${HOME}/.config/kind
noblacklist ${HOME}/.minikube
noblacklist ${HOME}/.config/k3d
noblacklist ${HOME}/.config/colima
noblacklist ${HOME}/.colima
# Direnv / asdf-style task runners
noblacklist ${HOME}/.config/direnv
noblacklist ${HOME}/.local/share/direnv
noblacklist ${HOME}/.cache/direnv
noblacklist ${HOME}/.local/share/devbox
noblacklist ${HOME}/.local/share/devenv
# Shell config
noblacklist ${HOME}/.config/nushell
noblacklist ${HOME}/.config/fish
noblacklist ${HOME}/.config/starship.toml
noblacklist ${HOME}/.cache/starship
noblacklist ${HOME}/.config/oh-my-posh
noblacklist ${HOME}/.config/zoxide
noblacklist ${HOME}/.local/share/zoxide
noblacklist ${HOME}/.cache/zsh
noblacklist ${HOME}/.zsh
noblacklist ${HOME}/.oh-my-zsh
noblacklist ${HOME}/.config/atuin
noblacklist ${HOME}/.local/share/atuin
# Misc dev tooling caches
noblacklist ${HOME}/.cache/go-build
noblacklist ${HOME}/.cache/golangci-lint
noblacklist ${HOME}/.cache/goimports
noblacklist ${HOME}/.cache/typescript
noblacklist ${HOME}/.cache/eslint
noblacklist ${HOME}/.cache/prettier
noblacklist ${HOME}/.cache/ruff
noblacklist ${HOME}/.cache/mypy
noblacklist ${HOME}/.cache/pyright
noblacklist ${HOME}/.cache/pytest_cache
noblacklist ${HOME}/.cache/jest
noblacklist ${HOME}/.cache/vitest
noblacklist ${HOME}/.cache/cypress
noblacklist ${HOME}/.cache/playwright
noblacklist ${HOME}/.cache/ms-playwright
noblacklist ${HOME}/.cache/puppeteer
noblacklist ${HOME}/.cache/turborepo
noblacklist ${HOME}/.cache/nx
noblacklist ${HOME}/.cache/rush
noblacklist ${HOME}/.rush
noblacklist ${HOME}/.cache/gradle
noblacklist ${HOME}/.cache/coursier
noblacklist ${HOME}/.coursier

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
# --- Extra version managers ---------------------------------------------
whitelist ${HOME}/.asdf
whitelist ${HOME}/.config/asdf
whitelist ${HOME}/.config/mise
whitelist ${HOME}/.local/share/mise
whitelist ${HOME}/.local/state/mise
# --- Extra build / native toolchains ------------------------------------
whitelist ${HOME}/.bazel
whitelist ${HOME}/.cache/bazel
whitelist ${HOME}/.bazelisk
whitelist ${HOME}/.cache/bazelisk
whitelist ${HOME}/.buck2
whitelist ${HOME}/.cache/buck
whitelist ${HOME}/.cache/buck2
whitelist ${HOME}/.cache/pants
whitelist ${HOME}/.cache/pants.d
whitelist ${HOME}/.conan
whitelist ${HOME}/.conan2
whitelist ${HOME}/.cmake
whitelist ${HOME}/.vcpkg
whitelist ${HOME}/.config/vcpkg
whitelist ${HOME}/.cache/ccache
whitelist ${HOME}/.ccache
whitelist ${HOME}/.cache/sccache
whitelist ${HOME}/.config/sccache
whitelist ${HOME}/.cache/mold
# --- Extra Python tooling -----------------------------------------------
whitelist ${HOME}/.local/pipx
whitelist ${HOME}/.local/share/pipx
whitelist ${HOME}/.local/state/pipx
whitelist ${HOME}/.local/share/hatch
whitelist ${HOME}/.local/share/pdm
whitelist ${HOME}/.config/pdm
whitelist ${HOME}/.rye
whitelist ${HOME}/.tox
whitelist ${HOME}/.cache/pre-commit
whitelist ${HOME}/.cache/maturin
whitelist ${HOME}/.conda
whitelist ${HOME}/.config/conda
whitelist ${HOME}/miniconda3
whitelist ${HOME}/anaconda3
whitelist ${HOME}/mambaforge
whitelist ${HOME}/miniforge3
whitelist ${HOME}/.pixi
# --- Erlang / Elixir / Lua / R / Lean / Swift / Clojure / Crystal / D / Zig / Wasm ----
whitelist ${HOME}/.mix
whitelist ${HOME}/.hex
whitelist ${HOME}/.config/rebar3
whitelist ${HOME}/.cache/rebar3
whitelist ${HOME}/.kerl
whitelist ${HOME}/.luarocks
whitelist ${HOME}/.config/luarocks
whitelist ${HOME}/.cache/luarocks
whitelist ${HOME}/.R
whitelist ${HOME}/R
whitelist ${HOME}/.Renviron
whitelist ${HOME}/.Rprofile
whitelist ${HOME}/.cache/R
whitelist ${HOME}/.elan
whitelist ${HOME}/.swiftpm
whitelist ${HOME}/.config/swiftpm
whitelist ${HOME}/.cache/swift
whitelist ${HOME}/.clojure
whitelist ${HOME}/.config/clojure
whitelist ${HOME}/.lein
whitelist ${HOME}/.boot
whitelist ${HOME}/.cpcache
whitelist ${HOME}/.deps.clj
whitelist ${HOME}/.gitlibs
whitelist ${HOME}/.cache/crystal
whitelist ${HOME}/.crystal
whitelist ${HOME}/.dub
whitelist ${HOME}/.cache/zig
whitelist ${HOME}/.zig
whitelist ${HOME}/.cache/gleam
whitelist ${HOME}/.cache/roc
whitelist ${HOME}/.racket
whitelist ${HOME}/.config/racket
whitelist ${HOME}/.roswell
whitelist ${HOME}/.quicklisp
whitelist ${HOME}/.sbclrc
whitelist ${HOME}/.cache/chicken-install
whitelist ${HOME}/.chicken
whitelist ${HOME}/.wasmer
whitelist ${HOME}/.wasmtime
whitelist ${HOME}/.wasmedge
# --- Extra DevOps / k8s / IaC -------------------------------------------
whitelist ${HOME}/.docker
whitelist ${HOME}/.skaffold
whitelist ${HOME}/.tilt-dev
whitelist ${HOME}/.config/k9s
whitelist ${HOME}/.config/lazygit
whitelist ${HOME}/.config/lazydocker
whitelist ${HOME}/.config/gh-dash
whitelist ${HOME}/.kustomize
whitelist ${HOME}/.config/kustomize
whitelist ${HOME}/.config/helmfile
whitelist ${HOME}/.cache/helm
whitelist ${HOME}/.cache/kubectl
whitelist ${HOME}/.config/kind
whitelist ${HOME}/.minikube
whitelist ${HOME}/.config/k3d
whitelist ${HOME}/.config/colima
whitelist ${HOME}/.colima
# --- Direnv / devbox / devenv -------------------------------------------
whitelist ${HOME}/.config/direnv
whitelist ${HOME}/.local/share/direnv
whitelist ${HOME}/.cache/direnv
whitelist ${HOME}/.local/share/devbox
whitelist ${HOME}/.local/share/devenv
# --- Shell config (read-only later) -------------------------------------
whitelist ${HOME}/.config/nushell
whitelist ${HOME}/.config/fish
whitelist ${HOME}/.config/starship.toml
whitelist ${HOME}/.cache/starship
whitelist ${HOME}/.config/oh-my-posh
whitelist ${HOME}/.config/zoxide
whitelist ${HOME}/.local/share/zoxide
whitelist ${HOME}/.cache/zsh
whitelist ${HOME}/.zsh
whitelist ${HOME}/.oh-my-zsh
whitelist ${HOME}/.config/atuin
whitelist ${HOME}/.local/share/atuin
# --- Common dev caches ---------------------------------------------------
whitelist ${HOME}/.cache/go-build
whitelist ${HOME}/.cache/golangci-lint
whitelist ${HOME}/.cache/goimports
whitelist ${HOME}/.cache/typescript
whitelist ${HOME}/.cache/eslint
whitelist ${HOME}/.cache/prettier
whitelist ${HOME}/.cache/ruff
whitelist ${HOME}/.cache/mypy
whitelist ${HOME}/.cache/pyright
whitelist ${HOME}/.cache/pytest_cache
whitelist ${HOME}/.cache/jest
whitelist ${HOME}/.cache/vitest
whitelist ${HOME}/.cache/cypress
whitelist ${HOME}/.cache/playwright
whitelist ${HOME}/.cache/ms-playwright
whitelist ${HOME}/.cache/puppeteer
whitelist ${HOME}/.cache/turborepo
whitelist ${HOME}/.cache/nx
whitelist ${HOME}/.cache/rush
whitelist ${HOME}/.rush
whitelist ${HOME}/.cache/gradle
whitelist ${HOME}/.cache/coursier
whitelist ${HOME}/.coursier
# Podman (REMOTE socket pattern only — local rootless podman is incompatible
# with `noroot` + `nonewprivs` + `seccomp` below). The agent talks to a
# `podman system service` running on the host via CONTAINER_HOST. The shell
# wrapper injects CONTAINER_HOST=unix:///run/user/$UID/podman/podman.sock
# automatically when that socket exists.
#
# Enable on the host with:  systemctl --user enable --now podman.socket
#
# auth.json (registry creds) is blacklisted below.
whitelist ${HOME}/.config/containers
whitelist ${HOME}/.local/share/containers
whitelist ${HOME}/.cache/containers
# Rootless API socket dir — the only path the in-jail client needs.
whitelist /run/user/*/podman
read-write /run/user/*/podman

# firejail-agents notice source for the per-project $PWD/FIREJAIL.md symlink.
whitelist ${HOME}/.agents

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
read-only ${HOME}/.agents

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
read-only ${HOME}/.gvm
read-only ${HOME}/.gvm/bin
read-only ${HOME}/.gvm/go/bin
read-only ${HOME}/.gvm/tools-bin
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
# Local LLM tooling
read-only ${HOME}/.lmstudio
read-only ${HOME}/.lmstudio/bin
read-only ${HOME}/.lmstudio-home-pointer

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
blacklist ${HOME}/.config/containers/auth.json
blacklist ${RUNUSER}/containers/auth.json
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
# Agents need outbound for package installs / API calls. We deliberately
# share the host's network namespace (no `net` / `netfilter` / `dns`
# directives) so the jail inherits whatever the host has — including
# VPN routes, host /etc/resolv.conf, custom MTU, split-tunnels, etc.
# Adding `netfilter` or `dns` here would either require a fresh net
# namespace (breaking VPN routing) or override the resolver and cause
# DNS leaks / failures. Override with `net none` in code-agent.local
# for an air-gapped run.

private-etc alternatives,ca-certificates,crypto-policies,resolv.conf,hosts,host.conf,hostname,nsswitch.conf,localtime,timezone,ssl,pki,gai.conf,protocols,services,login.defs,passwd,group,shells,terminfo,fonts,gitconfig,gitattributes,profile,profile.d,bash.bashrc,zsh,inputrc,nanorc,vimrc,vim,xdg,java-*,maven,gradle,containers,subuid,subgid,cni,networks

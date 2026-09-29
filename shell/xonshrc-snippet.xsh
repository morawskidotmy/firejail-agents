# ▰▱▰▱▰  firejail-agents: BEGIN  ▰▱▰▱▰
# ───── Firejailed coding agents ────────────────────────────────────────────
# Each alias jails its agent so it can only see:
#   1. $PWD (the directory you launch it from) and its subtree
#   2. that agent's own config dir + ~/.gitconfig + dev toolchain caches
#   3. nothing else in $HOME (no ~/.ssh, ~/.mozilla, password stores, …)
# To bypass the jail for one invocation:    nojail amp …
# To peek at what the jail sees:            firejail --profile=amp --whitelist="$PWD" ls ~

import os
import shutil
import stat
import subprocess
import sys
from pathlib import Path


def _code_agent_jail(profile: str, binary: str, args: list[str]) -> int:
    """Run an agent under its Firejail profile."""
    cwd = os.path.realpath(os.getcwd())
    notice_src = os.path.expanduser("~/.agents/firejail/FIREJAIL.md")
    notice_firejail = os.path.join(cwd, "FIREJAIL.md")
    firejail_installed = False

    if os.path.isfile(notice_src) and not os.path.lexists(notice_firejail):
        try:
            os.symlink(notice_src, notice_firejail)
            firejail_installed = True
        except OSError:
            pass

    sock = os.path.join(
        os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"),
        "podman/podman.sock",
    )
    profile_dir = os.environ.get(
        "XDG_CONFIG_HOME", os.path.join(str(Path.home()), ".config")
    )
    cmd = [
        "firejail",
        "--quiet",
        f"--profile={profile_dir}/firejail/{profile}.profile",
        f"--whitelist={cwd}",
    ]
    try:
        if os.path.exists(sock) and stat.S_ISSOCK(os.stat(sock).st_mode):
            cmd.append(f"--env=CONTAINER_HOST=unix://{sock}")
        return subprocess.call(cmd + [binary] + list(args))
    finally:
        if firejail_installed and os.path.islink(notice_firejail):
            try:
                if os.readlink(notice_firejail) == notice_src:
                    os.unlink(notice_firejail)
            except OSError:
                pass


def _make_jail_wrapper(agent_name: str):
    """Create a Xonsh callable alias for a jailed agent."""
    def _wrapper(args, stdin=None, stdout=None, stderr=None, spec=None):
        binary = shutil.which(agent_name, path=os.pathsep.join(map(str, $PATH)))
        if not binary:
            print(f"{agent_name}: not found on PATH", file=sys.stderr)
            return 127
        return _code_agent_jail(agent_name, binary, args)

    return _wrapper


def _code_agent_nojail(args, stdin=None, stdout=None, stderr=None, spec=None):
    """Run a command directly, bypassing its Xonsh alias."""
    if not args:
        print("usage: nojail command [args ...]", file=sys.stderr)
        return 2
    binary = shutil.which(args[0], path=os.pathsep.join(map(str, $PATH)))
    if not binary:
        print(f"{args[0]}: not found on PATH", file=sys.stderr)
        return 127
    return subprocess.call([binary] + list(args[1:]))


# Derive aliases from installed profiles. The executable is resolved at call
# time, so PATH changes made later in .xonshrc are respected.
_code_agent_profile_dir = Path(
    os.environ.get("XDG_CONFIG_HOME", os.path.join(str(Path.home()), ".config"))
) / "firejail"
if _code_agent_profile_dir.is_dir():
    for _code_agent_profile in sorted(_code_agent_profile_dir.glob("*.profile")):
        _code_agent_name = _code_agent_profile.stem
        if _code_agent_name != "code-agent":
            aliases[_code_agent_name] = _make_jail_wrapper(_code_agent_name)

aliases["nojail"] = _code_agent_nojail
# ▰▱▰▱▰  firejail-agents: END  ▰▱▰▱▰

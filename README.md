# Dev Environment

## Quick start (new machine)

```bash
curl -fsSL https://raw.githubusercontent.com/state-of-th-art/setup-machine/main/resources/setup | bash
```

Notes:
- If you use a different repo URL, set `REPO_URL_OVERRIDE` before running the script.
- The setup script clones this repo to `~/personal/setup-machine`, runs `./run <tool>` scripts, and then applies dotfiles via `./dev-env`.

## Manual setup

```bash
git clone <your-repo-url> ~/personal/setup-machine
cd ~/personal/setup-machine
export DEV_ENV="$HOME/personal/setup-machine"

./run core
./run node
./run rust
./run neovim
./run tmux
./run lazygit
./dev-env
```

## Windows (native, winget)

Open PowerShell and run:

```powershell
git clone <your-repo-url> $env:USERPROFILE\personal\setup-machine
cd $env:USERPROFILE\personal\setup-machine
$env:DEV_ENV = "$env:USERPROFILE\personal\setup-machine"

.\run.ps1 core
.\run.ps1 node
.\run.ps1 rust
.\run.ps1 neovim
.\run.ps1 tmux
.\run.ps1 lazygit
.\dev-env.ps1
```

Note: If PowerShell blocks script execution, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Windows quick start (new machine):

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "iwr -UseBasicParsing https://raw.githubusercontent.com/state-of-th-art/setup-machine/main/resources/setup.ps1 | iex"
```

## Neovim LSP install

LSP servers are managed by `mason.nvim`. After first launch:

1. Open Neovim and run `:Mason`.
2. Ensure servers like `ts_ls`, `rust_analyzer`, `lua_ls`, `tailwindcss`, `elmls` are installed.

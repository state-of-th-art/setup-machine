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

## Neovim config sync

```bash
./run nvim-config-sync
```

This copies the Neovim config from `env/.config/nvim` in this repo to `~/.config/nvim`.

## Windows (native, winget)

Open PowerShell and run:

```powershell
git clone <your-repo-url> $env:USERPROFILE\personal\setup-machine
cd $env:USERPROFILE\personal\setup-machine
$env:DEV_ENV = "$env:USERPROFILE\personal\setup-machine"

powershell -ExecutionPolicy Bypass -File .\run.ps1 core
powershell -ExecutionPolicy Bypass -File .\run.ps1 node
powershell -ExecutionPolicy Bypass -File .\run.ps1 rust
powershell -ExecutionPolicy Bypass -File .\run.ps1 neovim
powershell -ExecutionPolicy Bypass -File .\run.ps1 tmux
powershell -ExecutionPolicy Bypass -File .\run.ps1 lazygit
powershell -ExecutionPolicy Bypass -File .\dev-env.ps1
```

Note: The commands above use `-ExecutionPolicy Bypass` so you do not need to change system policy.

Windows quick start (new machine):

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -Command "iwr -UseBasicParsing https://raw.githubusercontent.com/state-of-th-art/setup-machine/main/resources/setup.ps1 | iex"
```

## Neovim LSP install

LSP servers are managed by `mason.nvim`. After first launch:

1. Open Neovim and run `:Mason`.
2. Ensure servers like `ts_ls`, `rust_analyzer`, `lua_ls`, `tailwindcss`, `elmls` are installed.

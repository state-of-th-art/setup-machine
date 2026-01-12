# Dev Environment

## Quick start (new machine)

```bash
curl -fsSL https://raw.githubusercontent.com/CHANGE_ME/setup-machine/main/resources/setup | bash
```

Notes:
- If you use a different repo URL, set `REPO_URL_OVERRIDE` before running the script.
- The setup script clones this repo to `~/personal/dev`, runs `./run <tool>` scripts, and then applies dotfiles via `./dev-env`.

## Manual setup

```bash
git clone <your-repo-url> ~/personal/dev
cd ~/personal/dev
export DEV_ENV="$HOME/personal/dev"

./run core
./run node
./run rust
./run neovim
./run tmux
./run lazygit
./dev-env
```

## Neovim LSP install

LSP servers are managed by `mason.nvim`. After first launch:

1. Open Neovim and run `:Mason`.
2. Ensure servers like `ts_ls`, `rust_analyzer`, `lua_ls`, `tailwindcss`, `elmls` are installed.

# Neovim Configuration

A well-structured, modular Neovim configuration using Lua and lazy.nvim.

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point (minimal)
├── lua/
│   ├── core/               # Core Neovim configuration
│   │   ├── init.lua        # Core initialization
│   │   ├── options.lua     # Basic vim options
│   │   ├── keymaps.lua     # Global keymaps
│   │   ├── highlights.lua  # Custom highlights
│   │   └── autocmds.lua    # Autocommands
│   ├── config/             # Configuration modules
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── diagnostics.lua # Diagnostic configuration
│   │   ├── snippets.lua    # Snippets configuration
│   │   └── plugins/        # Plugin configurations
│   │       ├── *.lua       # Individual plugin configs
│   │       └── color-schemes/
│   ├── utils/              # Utility functions
│   │   └── diagnostics.lua # Diagnostic utilities
│   └── snippets/           # Custom snippets
├── after/                  # After-load configurations
│   └── ftplugin/          # Filetype-specific settings
└── lazy-lock.json         # Plugin lock file
```

## Key Features

### 🎯 **Modular Design**
- **Separation of Concerns**: Each aspect of the configuration is in its own file
- **Easy Maintenance**: Find and modify specific settings quickly
- **Scalable**: Add new features without cluttering existing files

### 🔧 **Core Configuration**
- **`core/options.lua`**: All basic vim options in one place
- **`core/keymaps.lua`**: Global keymaps organized by functionality
- **`core/highlights.lua`**: Custom colors and highlights
- **`core/autocmds.lua`**: Autocommands for various filetypes and events

### 📦 **Plugin Management**
- **lazy.nvim**: Fast and efficient plugin manager
- **Organized Structure**: Plugins grouped by functionality
- **Color Schemes**: Separate directory for theme configurations

### 🛠 **Utilities**
- **Diagnostic Tools**: Advanced error reporting and copying
- **AI-Friendly**: Format diagnostics for AI consumption
- **Interactive**: Choose which diagnostics to copy

## Key Mappings

### Buffer Management
- `<S-h>/<S-l>`: Navigate between buffers
- `<A-1-9>`: Go to specific buffer
- `<A-p>`: Pin/unpin buffer
- `<A-c>`: Close buffer
- `<leader>bn/bD/bL`: Sort buffers by name/directory/language
- `<leader>bl/br`: Close buffers to the left/right
- `<leader>bc/bp`: Close all but current/pinned buffers

### Navigation
- `<C-h/j/k/l>`: Window navigation
- `<C-Up/Down/Left/Right>`: Window resizing

### Search & Replace
- `<leader>s`: Search for word under cursor
- `<leader>p`: Paste without yanking
- `<leader>y`: Yank to system clipboard

### Find / Files (Telescope)
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fw`: Find word under cursor
- `<leader>fe`: Find errors
- `<leader>fn`: Find in notes
- `<leader>fb`: File browser (current file dir)
- `<leader>fB`: File browser (project)
- `<leader><leader>`: Recent files

### Diagnostics
- `<leader>cai`: Copy all errors for AI
- `<leader>cb`: Copy current buffer errors
- `<leader>cd`: Interactive diagnostic copier
- `[d/]d`: Navigate diagnostics
- `[e/]e`: Navigate errors only
- `<leader>ld`: Line diagnostics
- `<leader>lq`: Diagnostics to loclist

### Git
- `<leader>gb`: Toggle Git blame
- `<leader>lg`: LazyGit

### Theme
- `<leader>tt`: Toggle theme

## Plugin Highlights

### Essential Plugins
- **lazy.nvim**: Plugin manager
- **nvim-lspconfig**: LSP configuration
- **blink.cmp**: Completion
- **telescope.nvim**: Fuzzy finder
- **File explorer**: Telescope file browser (netrw disabled to prevent errors)
- **barbar**: Buffer tabs


### Development
- **treesitter**: Syntax highlighting
- **luasnip**: Snippets
- **comment.nvim**: Commenting
- **indent-blankline**: Indent guides

### Git Integration
- **lazy-git**: Git interface
- **diffview**: Diff viewer
- **git-blame**: Git blame

## Customization

### Adding New Plugins
1. Create a new file in `lua/config/plugins/`
2. Follow the lazy.nvim specification
3. The plugin will be automatically loaded

### Modifying Keymaps
- Core (non-plugin) keymaps: `lua/core/keymaps.lua`
- Plugin-specific keymaps: their `lua/config/plugins/*.lua` file
- which-key groups: `lua/config/plugins/which-key.lua`

### Adding Filetype Settings
- Use `lua/after/ftplugin/` for filetype-specific settings
- Or add to `lua/core/autocmds.lua` for autocommands

### Custom Functions
- Add utility functions to `lua/utils/`
- Import and use them in your configurations

## Benefits of This Structure

1. **Maintainability**: Easy to find and modify specific settings
2. **Readability**: Clear separation of concerns
3. **Scalability**: Easy to add new features
4. **Debugging**: Isolated components make troubleshooting easier
5. **Collaboration**: Others can easily understand and contribute
6. **Performance**: Modular loading reduces startup time

## Migration from Old Structure

The old monolithic `init.lua` has been broken down into:
- **Core settings** → `lua/core/options.lua`
- **Keymaps** → `lua/core/keymaps.lua`
- **Highlights** → `lua/core/highlights.lua`
- **Diagnostics** → `lua/config/diagnostics.lua`
- **Snippets** → `lua/config/snippets.lua`
- **Utility functions** → `lua/utils/diagnostics.lua`

## Tips

1. **Start Small**: Begin with the core files and add plugins as needed
2. **Use Comments**: Document your customizations
3. **Test Incrementally**: Add changes one at a time
4. **Backup**: Keep a backup of your working configuration
5. **Version Control**: Use Git to track changes

This structure provides a solid foundation for a maintainable and extensible Neovim configuration. 

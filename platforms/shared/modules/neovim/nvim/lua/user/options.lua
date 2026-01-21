vim.g.have_nerd_font = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1 -- disable netrw in favor of nvim-tree
vim.g.loaded_netrwPlugin = 1

local options = {
  -- cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  -- pumheight = 10,                          -- pop up menu height
  autoread = true,
  background = 'dark',
  backup = false, -- creates a backup file
  breakindent = true,
  clipboard = '', -- don't sync unnamed clipboard with system
  -- clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  colorcolumn = '100', -- color column 100
  conceallevel = 0, -- so that `` is visible in markdown files
  confirm = true,
  cursorcolumn = true, -- highlight the current line
  cursorline = true, -- highlight the current line
  expandtab = true, -- convert tabs to spaces
  fileencoding = 'utf-8', -- the encoding written to a file
  guifont = 'Sauce_Code_Pro_Nerd_Font_Complete:h14', -- the font used in graphical neovim applications
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  inccommand = 'split',
  list = true,
  mouse = 'a', -- allow the mouse to be used in neovim
  mousemodel = 'extend', -- allow the mouse to be used in neovim
  number = true, -- set numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  relativenumber = false, -- set relative numbered lines
  ruler = true,
  scrolloff = 8, -- is one of my fav
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  shortmess = 'aoOtIF',
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  -- showtabline = 2,                         -- always show tabs
  sidescrolloff = 8,
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  smartcase = true, -- smart case (use case senstive if using /C or search contains capital letter)
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  tabstop = 2, -- insert 2 spaces for a tab
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeout = true,
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 250, -- faster completion (4000ms default)
  wrap = false, -- display lines as one long line
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  vim.o[k] = v
end

--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

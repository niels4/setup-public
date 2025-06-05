vim.g.have_nerd_font = true

local options = {
  -- backup = false,                          -- creates a backup file
  -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  background = 'dark',
  autoread = true,
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = 'utf-8', -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  mouse = 'a', -- allow the mouse to be used in neovim
  mousemodel = 'extend', -- allow the mouse to be used in neovim
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  ignorecase = true, -- ignore case in search patterns
  smartcase = true, -- smart case (use case senstive if using /C or search contains capital letter)
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeout = true,
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 250, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  tabstop = 2, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  cursorcolumn = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = false, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 8, -- is one of my fav
  sidescrolloff = 8,
  colorcolumn = '100', -- color column 100
  ruler = true,
  guifont = 'Sauce_Code_Pro_Nerd_Font_Complete:h14', -- the font used in graphical neovim applications
  shortmess = 'aoOtIF',
  breakindent = true,
  clipboard = '', -- don't sync unnamed clipboard with system
  -- clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  -- cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  -- pumheight = 10,                          -- pop up menu height
  -- showtabline = 2,                         -- always show tabs
}

for k, v in pairs(options) do
  vim.o[k] = v
end

vim.g.loaded_netrw = 1 -- disable netrw in favor of nvim-tree
vim.g.loaded_netrwPlugin = 1

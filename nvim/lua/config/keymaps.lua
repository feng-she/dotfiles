-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })

local function def_vsplit()
  vim.cmd("vsplit")
  vim.cmd("wincmd l") -- 确保到右窗
  vim.lsp.buf.definition({ reuse_win = false })
end

local function def_split()
  vim.cmd("split")
  vim.cmd("wincmd j") -- 确保到下窗
  vim.lsp.buf.definition({ reuse_win = false })
end

local function def_tab()
  vim.cmd("tab split")
  vim.lsp.buf.definition({ reuse_win = false })
end

vim.keymap.set("n", "gV", def_vsplit, { desc = "Goto Definition (vsplit)" })
vim.keymap.set("n", "gH", def_split, { desc = "Goto Definition (split)" })
vim.keymap.set("n", "gT", def_tab, { desc = "Goto Definition (tab)" })

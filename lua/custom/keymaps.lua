-- [[ keymaps: ':map' stuff ]] --

-- <Space> as a <Leader> key
vim.g.mapleader = " "

local mappings = {
  -- insert
  i = {
    -- Esc alternative
    ["kj"] = "<Esc>",
  },

  -- normal
  n = {
    -- clear search highlights and last executed command with <Esc>
    ["<Esc>"] = "<Esc><Cmd>noh <Bar> echo ''<CR>",

    -- frequently used commands
    ["<Leader>w"] = "<Cmd>silent write<CR>",
    ["<Leader>W"] = "<Cmd>silent wall<CR>",
    ["<Leader>q"] = "<Cmd>quit<CR>",
    ["<Leader>Q"] = "<Cmd>quit!<CR>",
    ["<Leader>t"] = "<Cmd>term<CR>",

    -- open cmdline window with `:lua =` prefilled
    ["<Leader>="] = ":lua =",

    -- I hate magic
    -- ["/"] = { "/\\V" }, -- very nomagic
    -- ["?"] = { "?\\V" }, -- very nomagic

    -- I like very magic
    ["g/"] = "/\\v", -- very magic
    ["g?"] = "?\\v", -- very magic

    -- tab navigation
    ["]t"] = "gt",
    ["[t"] = "gT",
    ["]T"] = "<Cmd>tabmove +1<CR>",
    ["[T"] = "<Cmd>tabmove -1<CR>",

    ["<Leader>1"] = "1gt",
    ["<Leader>2"] = "2gt",
    ["<Leader>3"] = "3gt",
    ["<Leader>4"] = "4gt",

    ["<Leader>+"] = "<Cmd>tabnew<CR>",
    ["<Leader>-"] = "<Cmd>tabclose<CR>",
    ["<Leader>0"] = "<Cmd>tabonly<CR>",

    -- -- yes I use colemak, how could you tell?
    -- ["<C-w>h"] = "<C-w>h",
    -- ["<C-w>n"] = "<C-w>j",
    -- ["<C-w>e"] = "<C-w>k",
    -- ["<C-w>i"] = "<C-w>l",

    -- ["<M-h>"] = "h",
    -- ["<M-n>"] = "j",
    -- ["<M-e>"] = "k",
    -- ["<M-i>"] = "l",
  },

  -- normal & visual
  [{ "n", "v" }] = {
    [" "] = "",

    -- scroll page with mouse wheel
    ["<Up>"] = "<C-y>",
    ["<Down>"] = "<C-e>",

    -- delete without worrying about yanked content
    ["yp"] = [["0p]], -- paste from yank register
    ["yd"] = [["0d]], -- delete into yank register
  },

  -- text object
  [{ "o", "v" }] = {
    ["."] = "iw",
    [","] = "aW",
    ["ae"] = function()
      vim.cmd("norm! m'vV")
      vim.cmd("keepjumps 0")
      vim.cmd("norm! o")
      vim.cmd("keepjumps $")
    end,
  },
}

local map = vim.keymap.set
for mode, mapping in pairs(mappings) do
  for lhs, rhs in pairs(mapping) do
    map(mode, lhs, rhs)
  end
end

local INSERT = "i"
local NORMAL = "n"
local VISUAL = "x"
local MOTION = { "n", "x" }
local TEXTOBJ = { "o", "x" }

-- local function cmd(s)
--   return ("<Cmd>%s<CR>"):format(s)
-- end

return {
  [INSERT] = {
    -- ESC alternative
    ["kj"] = "<Esc>",
  },

  [NORMAL] = {
    -- clear search highlights and cmdline output
    ["<Esc>"] = "<Esc><Cmd>noh <Bar> echo ''<CR>",

    -- frequently used commands
    ["<Leader>w"] = { "<Cmd>silent write<CR>", desc = "write" },
    ["<Leader>W"] = { "<Cmd>silent wall<CR>", desc = "wall" },
    ["<Leader>q"] = "<Cmd>quit<CR>",
    ["<Leader>Q"] = "<Cmd>quit!<CR>",

    ["<Leader>="] = ":lua =",
    ["<Leader>h"] = ":h ",

    -- FEAT: ASAP: open terminal in split/tab/current
    -- ["<Leader>t"] = "<Cmd>term<CR>",

    ["g/"] = { "/\\v", desc = "regex search" },
    ["g?"] = { "/\\V", desc = "literal search" },

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
  },

  [VISUAL] = {
    -- ["<"] = "<gv",
    -- [">"] = ">gv",
  },

  [MOTION] = {
    -- scroll with mouse wheel
    -- ["<Up>"] = "<C-y>",
    -- ["<Down>"] = "<C-e>",

    -- delete without worrying about yanked content
    ["yp"] = [["0p]], -- paste from yank register
    ["yd"] = [["0d]], -- delete into yank register

    -- FEAT: LATER: configure ALT+HNEI to HJKL using kmonad
    ["<M-h>"] = "h",
    ["<M-n>"] = "j",
    ["<M-e>"] = "k",
    ["<M-i>"] = "l",

    -- yes I use colemak, how could you tell?
    ["<C-w>n"] = "<C-w>j",
    ["<C-w>e"] = "<C-w>k",
    ["<C-w>i"] = "<C-w>l",

    ["<C-w><C-n>"] = "<C-w>j",
    ["<C-w><C-e>"] = "<C-w>k",
    ["<C-w><C-i>"] = "<C-w>l",

    ["<C-w>N"] = "<C-W>J",
    ["<C-w>E"] = "<C-w>K",
    ["<C-w>I"] = "<C-w>L",
  },

  [TEXTOBJ] = {
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

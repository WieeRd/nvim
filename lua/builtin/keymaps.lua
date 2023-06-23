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
    -- clear search highlights and last executed command with <Esc>
    ["<Esc>"] = "<Esc><C-l>",

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

  [VISUAL] = {
    ["<"] = "<gv",
    [">"] = ">gv",
  },

  [MOTION] = {
    -- scroll with mouse wheel
    ["<Up>"] = "<C-y>",
    ["<Down>"] = "<C-e>",

    -- delete without worrying about yanked content
    ["yp"] = [["0p]], -- paste from yank register
    ["yd"] = [["0d]], -- delete into yank register
  },

  [TEXTOBJ] = {
    ["."] = "iw",
    [","] = "aW",
    ["ae"] = function()
      vim.cmd("norm! m'vV")
      vim.cmd("keepjumps 0")
      vim.cmd("keepjumps $")
    end,
  },
}

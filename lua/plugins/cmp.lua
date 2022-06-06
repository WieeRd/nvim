local vim = vim
local lspkind = require("lspkind")
local cmp = require("cmp")


-- check if there is a non-blank char before the cursor
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  if col == 0 then
    return false
  end

  local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[0]
  return text:sub(col, col):match("%s") == nil
end


-- open completion menu or execute fn(opt) if it's already open
local function complete_or_fn(fn, opt)
  return function(_)
    if cmp.visible() then
      fn(opt)
    else
      cmp.complete()
    end
  end
end


local function visible_buffers()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    bufs[vim.api.nvim_win_get_buf(win)] = true
  end
  return vim.tbl_keys(bufs)
end


cmp.setup({
  -- snippet = {
  --   expand = function(args)
  --     require("luasnip").lsp_expand(args.body)
  --   end,
  -- }, 

  view = {
    entries = {
      -- "native", "wildmenu", "custom"
      -- name = "custom",
      -- "top_down", "bottom_up", "near_cursor"
      -- selection_order = "near_cursor",
    }
  },                                                             

  window = {
    -- window borders look cool, but distracting
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  mapping = {
    -- works only if menu is already opened
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm(),

    -- opens completion menu if it's not visible
    ["<C-n>"] = complete_or_fn(cmp.select_next_item),
    ["<C-p>"] = complete_or_fn(cmp.select_prev_item),
    ["<C-Space>"] = complete_or_fn(cmp.confirm, { select = true }),
    ["<C-a>"] = cmp.mapping.abort(),

    -- why is +4 invalid in lua I want to line up columns :(
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),

    -- TODO: snippet mappings
    -- ["<C-h>"] =
    -- ["<C-l>"] =
  },

  sources = cmp.config.sources(
    -- primary completion sources
    {
      -- { name = "luasnip" },
      -- { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "path" },
    },

    -- fallback sources; used when none of above is available
    {
      {
        name = "buffer",
        keyword_length = 3,
        max_item_count = 5,
        option = { get_bufnrs = visible_buffers }
      },
      {
        name = "spell",
        keyword_length = 4,
        max_item_count = 5,
      },
    }
  ),

  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",  -- "text", "text_symbol", "symbol_text", "symbol"
      maxwidth = 50,
      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        path = "[PATH]",
        spell = "[SPELL]",
        luasnip = "[SNIP]",
        gh_issues = "[ISSUE]",
        tn = "[TABN]",
        cmdline = "[CMD]",
      },
    })
  },

  sorting = {
    -- TODO: still not sure about comparators
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- https://github.com/lukas-reineke/cmp-under-comparator
      -- lower priority for items starting with "_"
      function (entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      -- higher priority for words closer to the cursor
      -- function(...)
      --   return require("cmp_buffer"):compare_locality(...)
      -- end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },

    -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
    -- comparators = {
    --   cmp.config.compare.offset,
    --   cmp.config.compare.exact,
    --   -- cmp.config.compare.scopes,
    --   cmp.config.compare.score,
    --   cmp.config.compare.recently_used,
    --   cmp.config.compare.locality,
    --   cmp.config.compare.kind,
    --   cmp.config.compare.sort_text,
    --   cmp.config.compare.length,
    --   cmp.config.compare.order,
    -- },

  },

  experimental = { ghost_text = true },
})


-- cmdline completion have some problems atm
-- BUG: extreme lag when using `:Man` command
-- BUG: menu does not disappear when opening command-line window

local cmdline_mapping = {
  -- preserving <C-n>, <C-p> for browsing command history
  ["<Tab>"] = { c = complete_or_fn(cmp.select_next_item) },
  ["<S-Tab>"] = { c = complete_or_fn(cmp.select_prev_item) },
}

-- `:` cmdline setup
cmp.setup.cmdline(':', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmdline_mapping,
  sources = { { name = "cmdline", keyword_length = 2 } }
})

-- `/` cmdline setup
cmp.setup.cmdline('/', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmdline_mapping,
  sources = { { name = "buffer", max_item_count = 5 } }
})

-- `?` cmdline setup
cmp.setup.cmdline('?', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmdline_mapping,
  sources = { { name = "buffer", max_item_count = 5 } }
})

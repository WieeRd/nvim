local lspkind = require("lspkind")
local cmp = require("cmp")


-- check if there is a word before the cursor
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


lspkind.init()
cmp.setup({
  -- snippet = {
  --   expand = function(args)
  --     require("luasnip").lsp_expand(args.body)
  --   end,
  -- }, 

  window = {
    -- bordered window looks cool, but distracting
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  mapping = {
    -- works only if menu is already opened
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm(),

    -- opens completion menu if it's not visible
    ["<C-n>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end,
    ["<C-p>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end,
    ["<C-Space>"] = function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        cmp.complete()
      end
    end,
    ["<C-a>"] = cmp.mapping.abort(),

    -- why is +4 invalid in lua I want to line up columns :(
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),

    -- TODO: snippet mappings
    -- ["<C-h>"] =
    -- ["<C-l>"] =
  },

  sources = cmp.config.sources(
    {
      -- { name = "luasnip" },
      -- { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "path" },
    },
    {
      { name = "buffer", keyword_length = 3, max_item_count = 5 },
      { name = "spell", keyword_length = 4, max_item_count = 5 },
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
    -- TODO: locality comparator from cmp-buffer
    comparators = {
      cmp.config.compare.offset,  -- partial match index
      cmp.config.compare.exact,  -- prioritize exact matches
      cmp.config.compare.score,

      -- https://github.com/lukas-reineke/cmp-under-comparator
      -- less priority for items starting with "_"
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

-- TODO: preset.cmdline() breaks <C-p> <C-n> (browse command history)
cmdline_mapping = {

}

-- `:` cmdline setup
cmp.setup.cmdline(':', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "cmdline", keyword_length = 2 } }
})

-- `/` cmdline setup
cmp.setup.cmdline('/', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer", max_item_count = 5 } }
})

-- `?` cmdline setup
cmp.setup.cmdline('?', {
  window = { completion = cmp.config.window.bordered() },
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer", max_item_count = 5 } }
})

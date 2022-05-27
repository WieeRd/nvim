local lspkind = require("lspkind")
local cmp = require("cmp")


-- check if there is a word before the cursor
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


-- https://github.com/lukas-reineke/cmp-under-comparator
-- less priority for items starting with `_`
local function under_comparator(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end


lspkind.init()
cmp.setup({

  -- snippet = {
  --   expand = function(args)
  --     require("luasnip").lsp_expand(args.body)
  --   end,
  -- }, 

  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

    ["<C-f>"] = cmp.mapping.scroll_docs(-4),
    ["<C-b>"] = cmp.mapping.scroll_docs(4),

    ["<C-e>"] = cmp.mapping.abort(),

    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      { "i" }
    ),

    ["<C-Space>"] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })  -- behavior
        else
          cmp.complete()
          -- fallback()
        end
      end,
      { "i" }
    ),

    -- ["<Tab>"] = cmp.config.disable,

    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,

    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,

  },

  -- keyword_length
  -- max_item_count
  -- TODO: group_index - disable buffer sources when LSP is available
  sources = {
    -- { name = "luasnip" },
    -- { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer", keyword_length = 5, max_item_count = 5 },
    { name = "spell" }
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",  -- "text", "text_symbol", "symbol_text", "symbol"
      maxwidth = 50,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        spell = "[spell]",
        luasnip = "[snip]",
        gh_issues = "[Issue]",
        tn = "[TabN]",
      },
    })
  },

  sorting = {
    -- TODO: what are theeeese
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      under_comparator,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  experimental = { ghost_text = true },
})

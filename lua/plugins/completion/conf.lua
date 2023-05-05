local config = {}

config["nvim-cmp"] = function()
  local vim = vim
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip")

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

  -- list of buffers displayed in current tabpage
  local function visible_buffers()
    local bufs = {}
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(windows) do
      bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    return vim.tbl_keys(bufs)
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    view = {
      entries = {
        -- "native", "wildmenu", "custom"
        name = "custom",
        -- "top_down", "bottom_up", "near_cursor"
        selection_order = "near_cursor",
      },
    },

    window = {
      completion = {
        border = "none",
        winhighlight = "Search:None",
        side_padding = 1,
        scrollbar = true,
      },
      documentation = {
        border = "solid",
        winhighlight = "Search:None",
      },
    },

    mapping = {
      -- works only if menu is already opened
      ["<Tab>"] = { i = cmp.mapping.select_next_item() },
      ["<S-Tab>"] = { i = cmp.mapping.select_prev_item() },
      ["<CR>"] = { i = cmp.mapping.confirm() },

      -- opens completion menu if it's not visible
      ["<C-n>"] = { i = complete_or_fn(cmp.select_next_item) },
      ["<C-p>"] = { i = complete_or_fn(cmp.select_prev_item) },
      ["<C-Space>"] = { i = complete_or_fn(cmp.confirm, { select = true }) },

      -- revert to original text
      ["<C-a>"] = { i = cmp.mapping.abort() },

      -- why is +4 invalid in Lua I want to line up columns :(
      ["<C-f>"] = { i = cmp.mapping.scroll_docs(4) },
      ["<C-b>"] = { i = cmp.mapping.scroll_docs(-4) },

      -- NOTE: snippet keymaps are defined in LuaSnip config below
    },

    sources = cmp.config.sources(
      -- primary completion sources
      {
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lsp" },
        { name = "path" },
      },

      -- fallback sources; used when none of above is available
      {
        {
          name = "buffer",
          keyword_length = 3,
          max_item_count = 5,
          option = { get_bufnrs = visible_buffers },
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
        -- "text", "symbol", "text_symbol", "symbol_text"
        mode = "symbol_text",
        maxwidth = 50,
        menu = {
          buffer = "[BUF]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[API]",
          path = "[PATH]",
          spell = "[SPELL]",
          luasnip = "[SNIP]",
          gh_issues = "[ISSUE]",
          cmdline = "[CMD]",
        },
      }),
    },

    sorting = {
      comparators = {
        -- how 'accurate' the match is
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,

        -- lower priority for the items prefixed with '_'
        function(entry1, entry2)
          local _, entry1_under = entry1.completion_item.label:find("^_+")
          local _, entry2_under = entry2.completion_item.label:find("^_+")
          entry1_under = entry1_under or 0
          entry2_under = entry2_under or 0
          return entry1_under < entry2_under
        end,

        ---@diagnostic disable-next-line: assign-type-mismatch
        cmp.config.compare.recently_used,
        ---@diagnostic disable-next-line: assign-type-mismatch
        cmp.config.compare.locality,

        -- last resort
        cmp.config.compare.kind,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },

    experimental = { ghost_text = { hl = "NonText" } },
  })

  -- command line completion
  cmp.setup.cmdline(":", {
    window = {
      completion = {
        border = "rounded",
        winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
        scrollbar = true,
      },
    },
    mapping = {
      ["<Tab>"] = { c = complete_or_fn(cmp.select_next_item) },
      ["<S-Tab>"] = { c = complete_or_fn(cmp.select_prev_item) },
    },
    sources = {
      { name = "cmdline", keyword_length = 2 },
      { name = "path", keyword_length = 2 },
    },
  })

  -- clear completion menu when opening cmdline window
  vim.api.nvim_create_autocmd("CmdwinEnter", {
    -- `callback = cmp.close` doesn't work somehow
    callback = function()
      cmp.close()
    end,
    group = vim.api.nvim_create_augroup("CmpCmdlineFix", { clear = true }),
  })
end

config["LuaSnip"] = function()
  local luasnip = require("luasnip")
  local map = vim.keymap.set

  luasnip.config.set_config({
    history = true,
    delete_check_events = "TextChanged,InsertLeave",
  })

  map({ "i", "s" }, "<C-h>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end)

  map({ "i", "s" }, "<C-l>", function()
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    end
  end)

  require("luasnip.loaders.from_lua").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_snipmate").lazy_load()
end

config["neogen"] = function()
  local neogen = require("neogen")
  local map = vim.keymap.set

  neogen.setup({
    snippet_engine = "luasnip",
    enable_placeholders = true,
    placeholders_hl = "NONE",
  })

  local annotation_convention = {}

  local function generate_doc(doc_type)
    return function()
      neogen.generate({
        type = doc_type,
        annotation_convention = annotation_convention,
      })
    end
  end

  -- change default annotation convention on the fly
  map("n", "<Leader>na", function()
    local filetype = vim.bo.filetype
    local doctype = vim.fn.input({
      prompt = ("annotation convention for %s: "):format(filetype),
    })
    if doctype ~= "" then
      annotation_convention[filetype] = doctype
    end
  end)

  map("n", "<Leader>ng", generate_doc("any"))
  map("n", "<Leader>nf", generate_doc("func"))
  map("n", "<Leader>nc", generate_doc("class"))
  map("n", "<Leader>nt", generate_doc("type"))
  map("n", "<Leader>nm", generate_doc("file"))
end

return config

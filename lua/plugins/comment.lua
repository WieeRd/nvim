require("Comment").setup({
  pre_hook = function(ctx)
    local U = require("Comment.utils")
    local ctx_util = require("ts_context_commentstring.utils")
    local ctx_intl = require("ts_context_commentstring.internal")

    -- Determine whether to use linewise or blockwise commentstring
    local type = (ctx.ctype == U.ctype.line) and "__default" or "__multiline"

    -- Determine the location where to calculate commentstring from
    local location = nil

    if ctx.ctype == U.ctype.block then
      location = ctx_util.get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = ctx_util.get_visual_start_location()
    end

    return ctx_intl.calculate_commentstring(
      { key = type, location = location }
    )
  end
})

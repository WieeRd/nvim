local vim = vim

return {
  ["Shrug"] = "echo 'It works on my machine ¯\\_(ツ)_/¯'",

  ["Eval"] = {
    function(opts)
      local cmd = vim.api.nvim_parse_cmd(opts.args, {})
      local output = vim.api.nvim_cmd(cmd, { output = true })
      vim.api.nvim_paste(output, true, -1)
    end,
    nargs = 1,
    desc = "paste the output of ex-command",
  },

  ["Bind"] = {
    function(opts)
      local enable = not opts.bang
      local windows = vim.api.nvim_tabpage_list_wins(0)
      for i = 1, #windows do
        local wo = vim.wo[windows[i]]
        wo.cursorline = enable
        wo.cursorbind = enable
        wo.scrollbind = enable
      end
    end,
    bang = true,
    desc = ":windo set cursorline cursorbind scrollbind",
  },
}

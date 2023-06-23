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
}

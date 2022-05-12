vim.cmd [[
augroup git_repo_check
  autocmd!
  autocmd VimEnter,DirChanged * call utils#Inside_git_repo() 
augroup END

" inside ~/.config/nvim/autoload/utils.vim
" Check if we are inside a Git repo
function! utils#Inside_git_repo() abort
  let res = system('git rev-parse --is-inside-work-tree')
  if match(res, 'true') == -1
    return v:false
  else
    " Trigger a speical user autocmd
    doautocmd User InGitRepo
    return v:true
  endif
endfunction
]]

-- delete comment EOL keybind

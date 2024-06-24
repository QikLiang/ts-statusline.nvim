function! TS_statusline(...) abort
  return luaeval("require'ts_statusline'(_A)", get(a:, 1, {}))
endfunction

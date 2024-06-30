This plugin is forked from [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)'s statusline module because
"[this code (and functionality) will be completely removed in the next version. Nvim-treesitter is focusing on installing parsers and curating queries](https://github.com/nvim-treesitter/nvim-treesitter/pull/6803#issuecomment-2185841545)".
I also made some changes to make it more robust to code formatting by relying more on treesitter for identifying the signature of a scope.
As a primarily C++ programmer, I also hard coded the default formatter to condense `func(very_long_parameter)` to `func(...)`, which can be configured with then `transform_fn` option.

# Usage
In vimscript, call `TS_statusline(opt)`. In lua, call `require'ts_tatusline'(opt)`.

To understand the configuration options, consider the simplified algorithm:
```lua
statusline = ""
local expr = vim.treesitter.get_node()
while expr do
  if is_statusline_scope(expr, type_patterns) then
    expr_text = ""
    for expr_child, field_name in expr:iter_children() do
      if not ignore_field(field_name) then
        expr_text += vim.treesitter.get_node_text(expr_child, bufnr)
      end
    end
    statusline += separator + transform_fn(expr_text)
  end
  expr = expr:parent()
end
```
In reference to the above algorithm, the `opt` parameter is expected to be a lua table such that
* `indicator_size` is the max length of the result, trimmed from the left. Default is `100`.
* `type_patterns` is a list of strings such that `is_statusline_scope` above returns true when `expr:type()` contains any of the substrings. Default is `{ "namespace", "class", "struct", "function", "method" }`.
* `ignore_fields` is a list of strings such that `ignore_field` above returns true if matching any one of the strings. Default is `{"body"}`.
* `transform_fn` is a function that formats the node text before appending to the result. Default is to convert one or more whitespaces to a single space, and contract `(...)` that is too long.
* `separator` is a string that delimits scopes. Default is `" -> "`.
* `allow_duplicates` is a boolean for whether to allow multiple scopes with the same text. Default `false`.

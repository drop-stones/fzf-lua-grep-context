-- Export utility functions and modules
return {
  get_plugin_root = require("fzf-lua-grep-context.util.get_plugin_root"),
  devicon = require("fzf-lua-grep-context.util.devicon"),
  table_concat = require("fzf-lua-grep-context.util.table_concat"),
  shellescape = require("fzf-lua-grep-context.util.shellescape"),
  parse_grep_contexts = require("fzf-lua-grep-context.util.parse_grep_contexts"),
  parse_grep_query = require("fzf-lua-grep-context.util.parse_grep_query"),
  startinsert = require("fzf-lua-grep-context.util.startinsert"),
  deep_extend_inplace = require("fzf-lua-grep-context.util.deep_extend_inplace"),
}

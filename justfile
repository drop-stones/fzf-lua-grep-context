default:
  @just --choose

generate_filetypes:
  nvim --headless "+luafile scripts/generate_filetypes.lua" +q

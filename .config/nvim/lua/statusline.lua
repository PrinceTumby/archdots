local table = table
local string = string
local vim = vim
local devicons = require("nvim-web-devicons")

local colours = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
  fg_inactive = '#5b626f',
  bg_inactive = '#1e2126',
  -- bg_inactive = '#13161b',
}

local mode_names = {
  n = "Normal",
  i = "Insert",
  R = "Replace",
  v = "Visual",
  V = "Visual",
  [''] = "Visual",
  s = "Select",
  S = "Select",
  [''] = "Select",
}

local mode_colours = {
  n = colours.green,
  i = colours.blue,
  R = colours.red,
  v = colours.orange,
  V = colours.orange,
  [''] = colours.orange,
  s = colours.orange,
  S = colours.orange,
  [''] = colours.orange,
}

local function set_highlight(group, fg, bg, bold)
  local bg = bg or colours.bg
  if bold == true then
    vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg .. " gui=bold cterm=bold")
  else
    vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
  end
end

function cosmosline_reload_colours()
  set_highlight("CosmoslineDefault", colours.fg, nil, true)
  set_highlight("CosmoslineInactive", colours.fg_inactive, colours.bg_inactive)
  set_highlight("CosmoslineSideBars", colours.blue)
  set_highlight("CosmoslineMode", mode_colours.n, nil, true)
  set_highlight("CosmoslineFileIcon", colours.fg, nil, true)
  set_highlight("CosmoslineFilename", colours.magenta, nil, true)
  set_highlight("CosmoslineRightText", colours.green, nil, true)
end

cosmosline_reload_colours()

function cosmosline_render()
  if vim.g.statusline_winid == vim.fn.win_getid(vim.fn.winnr()) then
    -- Active window
    -- Set mode colour
    local cur_mode = vim.fn.mode()
    set_highlight("CosmoslineMode", mode_colours[cur_mode] or mode_colours.n, nil, true)
    -- Get file icon and colour
    local file_name = vim.fn.expand("%:t")
    local file_ext = vim.fn.expand("%:e")
    local icon, icon_highlight = devicons.get_icon(file_name, file_ext)
    if icon == nil then
      icon = ""
    end
    set_highlight("CosmoslineFileIcon", vim.fn.synIDattr(vim.fn.hlID(icon_highlight), "fg"))
    return table.concat {
      -- Left hand side
      -- Left side bar
      "%#CosmoslineSideBars#▊ ",
      -- Current mode
      "%#CosmoslineMode#",
      mode_names[cur_mode] or mode_names.n,
      -- File icon
      -- "%#" .. (icon_highlight or "CosmoslineDefault") .. "#",
      "%#CosmoslineFileIcon#",
      "  " .. icon,
      -- File name
      " %#CosmoslineFilename#",
      "%f %h%w%m%r",
      -- Right hand side
      "%=%#CosmoslineRightText#",
      -- File type
      "%{&ft}  ",
      -- File encoding
      "%{&enc}  ",
      -- File format
      "%{&ff}  ",
      -- Current line / line count
      "%l/%L  ",
      -- Column number (plus virtual column number)
      "%2v  ",
      -- Percentage through file
      "%P ",
    }
  else
    -- Inactive windows
    return table.concat {
      -- Left hand side
      -- Set colours
      "%#CosmoslineInactive#",
      -- File name
      " %f %h%w%m%r",
      -- Right hand side
      "%= ",
      -- File type
      "%{&ft}  ",
      -- File encoding
      "%{&enc}  ",
      -- File format
      "%{&ff}  ",
      -- Current line / line count
      "%l/%L  ",
      -- Column number (plus virtual column number)
      "%2v  ",
      -- Percentage through file
      "%P ",
    }
  end
end

vim.o.statusline = "%!v:lua.cosmosline_render()"

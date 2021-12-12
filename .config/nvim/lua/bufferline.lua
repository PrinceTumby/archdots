local type = type
local table = table
local string = string
local vim = vim
local devicons = require("nvim-web-devicons")
local path_segment_pattern
local path_separator
local os = jit.os
if os == "Windows" then
  path_segment_pattern = "[^\\]*"
  path_separator = "\\"
else
  path_segment_pattern = "[^/]*"
  path_separator = "/"
end

local colours = {
  bg = '#303338',
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

local function set_highlight(group, fg, bg, bold)
  local bg = bg or colours.bg_inactive
  if bold == true then
    vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg .. " gui=bold cterm=bold")
  else
    vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
  end
end

function cosmostabs_reload_colours()
  set_highlight("CosmostabsDefault", colours.fg_inactive, colours.bg_inactive, true)
  set_highlight("CosmostabsActive", colours.fg, colours.bg, true)
  set_highlight("CosmostabsLineSeparator", colours.blue, colours.bg)
end

cosmostabs_reload_colours()

local filter_types = {
  help = true,
  qf = true,
  startify = true,
}

function cosmostabs_render()
  local tabline = "%#CosmostabsDefault#"
  local selected_buffer = vim.fn.bufnr()
  local buffers = vim.api.nvim_list_bufs()
  -- Associates path final segments with buffer ids
  local tail_index = {}
  -- Associates buffer ids with lists of segments
  local segment_index = {}
  -- Fill indexes from buffers
  for _, buffer in ipairs(buffers) do
    if vim.fn.buflisted(buffer) == 0 then goto continue end
    if filter_types[vim.fn.getbufvar(buffer, "&filetype")] then goto continue end
    -- Parse file path
    local file_path = vim.api.nvim_buf_get_name(buffer)
    -- TODO Implement detecting whether a buffer name is a file on disk
    if (file_path == "") then file_path = "[No Name]" end
    local segments = {}
    for segment in string.gmatch(file_path, path_segment_pattern) do
      if segment ~= "" then
        table.insert(segments, segment)
      end
    end
    -- Add empty string to end of unix paths so that root / gets added if required
    if os ~= "Windows" then
      table.insert(segments, 1, "")
    end
    -- Add to indexes
    ::index_adding::
    segment_index[buffer] = segments
    if tail_index[segments[#segments]] then
      local existing_entry = tail_index[segments[#segments]]
      if type(existing_entry) == "table" then
        -- Add buffer id to list
        table.insert(existing_entry, buffer)
      else
        -- Create list with existing buffer id
        tail_index[segments[#segments]] = {existing_entry, buffer}
      end
    else
      tail_index[segments[#segments]] = buffer
    end
    ::continue::
  end
  -- Associates buffer ids with generated unique names
  local buffer_names = {}
  for first_segment, tails in pairs(tail_index) do
    -- Initial check if first segment is already unique name
    if type(tails) == "number" then
      buffer_names[tails] = first_segment
      goto continue
    end
    -- Find lowest segment depth
    local lowest_depth = 99999
    for _, buffer in ipairs(tails) do
      lowest_depth = math.min(lowest_depth, #segment_index[buffer])
    end
    lowest_depth = lowest_depth - 1
    -- Associates buffer id with current depth from top
    local segment_depths = {}
    for _, buffer in ipairs(tails) do
      segment_depths[buffer] = #segment_index[buffer] - lowest_depth
      local potential_name = table.concat(
        segment_index[buffer],
        path_separator,
        (#segment_index[buffer]) - (#segment_index[buffer] - lowest_depth)
      )
      -- Generate a shortened version of the path, if it's too long
      if #potential_name > 25 then
        local shortened_segments = {}
        for _, segment in ipairs(segment_index[buffer]) do
          table.insert(shortened_segments, string.sub(segment, 1, 1))
        end
        shortened_segments[#shortened_segments] = segment_index[buffer][#shortened_segments]
        -- Preserve original length of root segment (for example "C:" on Windows)
        if lowest_depth == 1 then
          shortened_segments[1] = segment_index[buffer][1]
        end
        potential_name = table.concat(
          shortened_segments,
          path_separator,
          (#shortened_segments) - (#shortened_segments - lowest_depth)
        )
      end
      buffer_names[buffer] = potential_name
    end
    ::continue::
  end
  -- Render buffers into line
  for _, buffer in ipairs(buffers) do
    if vim.fn.buflisted(buffer) == 0 then goto continue end
    if filter_types[vim.fn.getbufvar(buffer, "&filetype")] then goto continue end
    -- TODO Implement unique file name generation
    local modified_text = ""
    if vim.fn.getbufvar(buffer, "&modified") == 1 then
      modified_text = "[+]"
    end
    if buffer == selected_buffer then
      tabline = table.concat {
        tabline,
        "%#CosmostabsLineSeparator#▊%#CosmostabsActive# ",
        buffer_names[buffer],
        modified_text,
        " %#CosmostabsDefault#",
      }
    else
      tabline = table.concat {
        tabline,
        " ",
        buffer_names[buffer],
        modified_text,
        " ",
      }
    end
    ::continue::
  end
  return tabline
end

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.cosmostabs_render()"

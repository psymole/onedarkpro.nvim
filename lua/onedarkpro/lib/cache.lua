local M = {}

local config = require("onedarkpro.config").config

local header_block = [[
-------------------------- AUTOGENERATED BY ONEDARKPRO -------------------------
]]

local clear_highlights_block = [[
if vim.g.colors_name then
  vim.cmd("hi clear")
end
]]

local footer_block = [[
-------------------------------------// END ------------------------------------
]]

--TODO: Add terminal colours to cache

---Generate the highlight groups that will be cached
---@return table
local function set_highlights_block(block)
    local highlight_block = {}
    local groups = require("onedarkpro.highlight")
    local highlights = require("onedarkpro.lib.highlight")

    -- Create the cache in the same way the theme creates highlight groups
    highlight_block = highlights.create(groups.editor, highlight_block)
    highlight_block = highlights.create(groups.syntax, highlight_block)
    highlight_block = highlights.create(groups.plugins, highlight_block)
    highlight_block = highlights.create(groups.custom, highlight_block)

    table.sort(highlight_block)
    table.insert(block, table.concat(highlight_block, "\n"))
    table.insert(block, "")

    return block
end

---The path to the cache file
---@param theme string
---@return string
local function cache_file(theme)
    theme = theme or vim.g.onedarkpro_theme
    return config.cache_path .. theme .. ".lua"
end

---Write the cache contents to disk
---@param contents table
---@return nil
local function write_cache(contents)
    require("onedarkpro.utils.init").ensure_dir(config.cache_path)

    local file = io.open(cache_file(), "w")
    if file then
        file:write(table.concat(contents, "\n"))
        file:close()
    end
end

---Check if a cache for the current theme exists
---@param theme string
---@return boolean
function M.exists(theme)
    return (vim.fn.filereadable(cache_file(theme)) ~= 0)
end

---Generate the cache file
---@return nil
function M.generate()
    -- In this scenario, a user has a cache file generated and has loaded from it
    -- They then change their config and want to regenerate the cache
    if vim.g.onedarkpro_cache_loaded then
        require("onedarkpro").load(true)
    end

    local cache = {}

    table.insert(cache, header_block)
    table.insert(cache, clear_highlights_block)
    set_highlights_block(cache)
    table.insert(cache, footer_block)

    if cache == nil then
        return
    end

    return write_cache(cache)
end

---Remove the cache file from disk
---@return nil
function M.clean()
    os.remove(cache_file())
end

---Load the cache file
---@return nil
function M.load(theme)
    vim.cmd("luafile " .. cache_file(theme.meta.name))
    vim.g.onedarkpro_cache_loaded = true

    require("onedarkpro.main").load(theme)
end

return M

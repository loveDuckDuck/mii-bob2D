Object = require 'libraries/classic/classic'

local Loader = Object:extend()

function Loader:new()
end

function Loader:getRequireFiles(files_path)
    local files_list = {}
    Loader:recursiveEnumerate(files_list, files_path)
    Loader:requireFiles(files_list)
    return files_list
end

function Loader:recursiveEnumerate(files_list, files_path)
    local items = love.filesystem.getDirectoryItems(files_path)
    for _, item in ipairs(items) do
        local file = files_path .. '/' .. item
        if love.filesystem.getInfo(file) then
            table.insert(files_list, file)
        elseif love.filesystem.isDirectory(file) then
            Loader:recursiveEnumerate(file, files_list)
        end
    end
end

function Loader:requireFiles(files_list)
    for _, file in ipairs(files_list) do
        local file = file:sub(1, -5)
        require(file)
    end
end

return Loader

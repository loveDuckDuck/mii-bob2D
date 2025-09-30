local Loader = Object:extend() -- Extends the object class 👨‍💻

function Loader:new()          -- Constructor function
end

function Loader:getRequireFiles(files_path)           -- Get files to require 📂
    local files_list = {}                             -- New files list 📄
    Loader:recursiveEnumerate(files_list, files_path) -- Enumerate files recursively 🔄
    Loader:requireFiles(files_list)                   -- Requires files 🚀
    return files_list                                 -- Returns the list 📜
end

function Loader:recursiveEnumerate(files_list, files_path)      -- Enumerate directories recursively 🌳
    local items = love.filesystem.getDirectoryItems(files_path) -- Get directory items 📁
    for _, item in ipairs(items) do                             -- Loop through items 🔎
        local file = files_path .. '/' .. item                  -- Build full file path 🛣️
        if love.filesystem.getInfo(file) then                   -- Check if file exists ✅
            table.insert(files_list, file)                      -- Insert into list ✍️
        elseif love.filesystem.isDirectory(file) then           -- Check if directory 📂
            Loader:recursiveEnumerate(file, files_list)         -- Recurse if directory 🔁
        end
    end
end

function Loader:requireFiles(files_list) -- Require the files 🧐
    for _, file in ipairs(files_list) do -- Loop through files 🔄
        local file = file:sub(1, -5)     -- Remove the extension ✂️
        require(file)                    -- Require the file ✨
    end
end

return Loader

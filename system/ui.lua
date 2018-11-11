local Filesystem = require('system/filesystem')
local UI = {}

local files = Filesystem.ls('system/ui')
for i,file in ipairs(files) do
    local filename = file.name:split('.')[1]
    local uiElement = require('system/ui/' .. filename)
    UI[filename] = uiElement

    print(filename)
end

return UI
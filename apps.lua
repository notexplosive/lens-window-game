local Filesystem = require('system/filesystem')
local Apps = {}

desktopState = {}
desktopState.content = {}
desktopState.isDesktop = true
Apps.names = {}

local files = Filesystem.ls('apps')
for i,file in ipairs(files) do
    local filename = file.name:split('.')[1]
    local app = require('apps/' .. filename)
    Apps[filename] = app
    append(Apps.names,filename)
    if app.showOnDesktop ~= false then
        append(desktopState.content,{name = app.iconName .. '.exe', app = filename, icon=app.icon})
    end
end

return Apps
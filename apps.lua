local Filesystem = require('system/filesystem')
local Apps = {}

desktopState = {}
desktopState.content = {}
desktopState.isDesktop = true
Apps.names = {}

local appFiles = Filesystem.ls('apps')
local games = Filesystem.ls('games')

function loadApps(path,files)
    for i,file in ipairs(files) do
        local filename = file.name:split('.')[1]
        local app = require(path..'/' .. filename)
        Apps[filename] = app
        append(Apps.names,filename)
    end
end

loadApps('games',games)
loadApps('apps',appFiles)

return Apps
local Filesystem = require('system/filesystem')
local Apps = {}

desktopState = {}
desktopState.content = {}
desktopState.isDesktop = true
Apps.names = {}

local appFiles = Filesystem.ls('apps')
local games = Filesystem.ls('games')

function loadApps(path,files)
    local output = {}
    for i,file in ipairs(files) do
        local filename = file.name:split('.')[1]
        local app = require(path..'/' .. filename)
        Apps[filename] = app
        app.slug = filename
        append(Apps.names,filename)
        append(output,app)
    end
    return output
end

local allGames = loadApps('games',games)
local allApps = loadApps('apps',appFiles)

function getAllGames()
    return allGames
end

function getAllApps()
    return allApps
end

return Apps
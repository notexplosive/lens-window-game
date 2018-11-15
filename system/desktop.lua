local Apps = require('apps')
local Vector = require('nx/vector')
local Window = require('system/window')
local Filesystem = require('system/filesystem')
local Desktop = {}

function Desktop.new()
    local self = newObject(Desktop)
    self.state = {
        isDesktop = true,
        content = {},
        dir = 'Desktop' -- So the system knows what dir the file lives in when clicked
    }

    -- Apps
    -- TODO: create a "FakeFile" system so we can add files to the virtual pc that aren't actually in the real world filesystem
    for i,name in ipairs(Apps.names) do
        local app = Apps[name]
        if app.showOnDesktop ~= false then
            append(self.state.content,{name = app.iconName .. '.exe', app = name, icon=app.icon})
        end
    end

    -- Actual files on desktop
    local content = Filesystem.inGameLS('Desktop')
    for i,v in ipairs(content) do
        append(self.state.content,v)
    end

    return self
end

function Desktop:update(dt)

end

local bg = love.graphics.newImage('images/bg.png')
function Desktop:draw()
    love.graphics.setColor(0.2, 0.6, 0.6)
    love.graphics.rectangle('fill',0,0,love.graphics.getDimensions())

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(bg)

    local mp = Vector.new(love.mouse.getPosition())
    if not State.loggingOff then
        drawIcons(self.state, nx_AllDrawableObjects[1].type ~= Window ,mp,true)
    end
end

return Desktop
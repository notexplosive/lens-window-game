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

    self.image = love.graphics.newImage('files/Pictures/solid.png')
    self.path = ''

    return self
end

function Desktop:update(dt)
    local bgState = State:get('background')
    if bgState ~= false and self.path ~= bgState then
        self.path = bgState
        self.image = love.graphics.newImage(self.path)
    end
end

function Desktop:draw()
    love.graphics.setColor(0.2, 0.6, 0.6)
    love.graphics.rectangle('fill',0,0,love.graphics.getDimensions())

    love.graphics.setColor(1,1,1,1)
    local scale = 1
    if self.image:getWidth() < love.graphics.getWidth() then
        scale = love.graphics.getWidth()/self.image:getWidth()
    end

    love.graphics.draw(self.image,
        love.graphics.getWidth()/2 - self.image:getWidth()*scale/2,
        love.graphics.getHeight()/2 - self.image:getHeight()*scale/2,
        0,
        scale,
        scale
    )

    local mp = Vector.new(love.mouse.getPosition())
    if not State.loggingOff then
        drawIcons(self.state, nx_AllDrawableObjects[1].type ~= Window ,mp,true)
    end
end

return Desktop
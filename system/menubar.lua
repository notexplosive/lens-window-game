local Window = require('system/window')
local Icons = require('system/icons')
local Vector = require('nx/vector')

local MenuBar = {}

MenuBar.OSColor = Window.OSColor

function MenuBar.new()
    local self = newObject(MenuBar)
    self.pos = Vector.new(0,love.graphics.getHeight() - Window.menuBarHeight)
    return self
end

function MenuBar:update(dt)
    self.pos = Vector.new(0,love.graphics.getHeight() - Window.menuBarHeight)
end

function MenuBar:draw(x,y)
    love.graphics.setColor(MenuBar.OSColor)
    love.graphics.rectangle('fill',x,y,love.graphics.getWidth(),Window.menuBarHeight)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('line',x,y,love.graphics.getWidth(),Window.menuBarHeight)
    local windows = Window.getAll()
    local iconWidth = 32 * 6
    local iconHeight = 32
    
    love.graphics.setFont(Icons.font)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(' 12:26 AM\n12/16/2008',love.graphics.getWidth() - 80,y+5)
    local oldFont = love.graphics.getFont()
    for i,window in ipairs(windows) do
        local iconX = x + (i-1) * (iconWidth+5) + 4
        local iconY = y + 3
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle('line',iconX,iconY,iconWidth,iconHeight)
        love.graphics.setColor(MenuBar.OSColor)

        if nx_AllDrawableObjects[1] ==  window then
            love.graphics.setColor(MenuBar.OSColor[1]*0.5,MenuBar.OSColor[2]*0.5,MenuBar.OSColor[3]*0.5)
        end

        local mx,my = love.mouse.getPosition()
        if isWithinBox(mx,my,iconX,iconY,iconWidth,iconHeight) then
            love.graphics.setColor(MenuBar.OSColor[1]*0.6,MenuBar.OSColor[2]*0.6,MenuBar.OSColor[3]*0.6)
            if gClickedThisFrame then
                window:maximize()
                window:bringToFront()
            end
        end

        love.graphics.rectangle('fill',iconX,iconY,iconWidth,iconHeight)
        love.graphics.setColor(1,1,1,1)
        if window.icon then
            local image,quad = Icons.getQuad(window.icon)
            love.graphics.draw(image,quad,iconX,iconY)
        end

        love.graphics.setFont(Icons.font)
        love.graphics.print(window.title,math.floor(iconX + 32) + 8,math.floor(iconY + 8))
    end

    love.graphics.setFont(oldFont)
end

return MenuBar
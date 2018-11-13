local Window = require('system/window')
local MousePointer = {}
local cursorImages = love.graphics.newImage('images/cursor.png')

function MousePointer.new()
    local self = newObject(MousePointer)
    self.quads = {}
    self.quads['pointer'] = love.graphics.newQuad(0,0,64,64, cursorImages:getDimensions())
    self.quads['select'] = love.graphics.newQuad(64,0,64,64, cursorImages:getDimensions())
    self.quads['text'] = love.graphics.newQuad(128,0,64,64, cursorImages:getDimensions())
    self.quads['diagonal'] = love.graphics.newQuad(192,0,64,64, cursorImages:getDimensions())
    self.quads['sideways'] = love.graphics.newQuad(64*4,0,64,64, cursorImages:getDimensions())
    self.currentQuad = 'pointer'
    self.flip = false
    self.angle = 0
    return self
end

function MousePointer:draw(x,y)
    love.graphics.setColor(1,1,1,1)
    local mx,my = love.mouse.getPosition()
    local sx = 1
    self:update()
    if self.flip then
        sx = -1
    end

    love.graphics.draw(cursorImages,self.quads[self.currentQuad],mx,my,self.angle,sx,1,16,16)
end

function MousePointer:update()
    local topWindow = Window.getTopWindow()
    local edge = nil
    if topWindow then
        if not love.mouse.isDown(1) then
            edge = topWindow.hoverCorner
        end
        if not edge then
            edge = topWindow.selectedCorner
        end
    end
    if topWindow and edge then
        self:setQuad('sideways')
        if edge == 'top' or edge == 'bottom' then
            self:setAngle(math.pi/2)
        end
        
        if edge ~= 'left' and edge ~= 'right' and edge ~= 'bottom' and edge ~= 'top' then
            self:setQuad('diagonal')
        end

        if edge == 'leftbottom' or edge == 'righttop' then
            -- Flip corner graphic
            self:setFlip(true)
        end
    end
end

function MousePointer:setQuad(name)
    self.currentQuad = name
end

function MousePointer:getQuad()
    return self.currentQuad
end

function MousePointer:setFlip(bool)
    self.flip = bool
end

function MousePointer:setAngle(n)
    self.angle = n
end

return MousePointer
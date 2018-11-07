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
    if self.flip then
        sx = -1
    end

    love.graphics.draw(cursorImages,self.quads[self.currentQuad],mx,my,self.angle,sx,1,16,16)
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
local Vector = require('nx/Vector')
local ButtonBase = {}

-- Button Base Class
function ButtonBase.new(label,x,y,onClick)
    local self = newObject(ButtonBase)
    self.pos = Vector.new(x,y)
    self.width = 128
    self.height = 32
    self.label = label
    self.justify = 'center'

    -- private
    self._wasPressed = false
    self.onClick = onClick
    if self.onClick == nil then
        function self:onClick()
            print(self.label,'NO BEHAVIOR DEFINED FOR ONCLICK')
        end
    end

    return self
end

function ButtonBase:update(dt)
end

function ButtonBase:draw(x,y,mp)
    local hover = isWithinBox(mp.x,mp.y,self.pos.x,self.pos.y,self.width,self.height)
    love.graphics.setColor(0.9,0.9,0.8,1)
    if self._wasPressed and hover then
        love.graphics.setColor(0.8,0.8,0.7,1)
    end
    love.graphics.rectangle('fill',x,y,self.width,self.height)
    
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line',x,y,self.width,self.height)
    if self._wasPressed and hover then
        love.graphics.setColor(0.4,0.4,1,1)
    else
        love.graphics.setColor(0.6,0.6,1,1)
    end
    love.graphics.rectangle('line',x+2,y+2,self.width-4,self.height-4)
    love.graphics.setColor(0,0,0)

    local textX = x + 3
    local textY = y + 3
    local font = love.graphics.getFont()
    if self.justify == 'center' then
        textX = x + self.width/2 - font:getWidth(self.label)/2
    end

    if not love.mouse.isDown(1) then
        if self._wasPressed and hover then
            self:onClick()
        end
        self._wasPressed = false
    end

    if hover and gClickedThisFrame then
        self._wasPressed = true
    end

    love.graphics.print(self.label,textX,textY)
end

return ButtonBase
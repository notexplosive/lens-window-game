local Vector = require('nx/Vector')
local ButtonBase = require('system/ui/buttonbase')

local Button = {}

-- Button Base Class
function Button.new(label,x,y,onClick)
    local self = ButtonBase.new(x,y,onClick)
    self.update = Button.update
    self.draw = Button.draw
    self.preOnClick = Button.preOnClick
    self.label = label
    return self
end

function Button:update(dt)
    self:baseUpdate(dt)
end

function Button:draw(x,y,mp)
    if self.baseDraw then
        self:baseDraw(x,y,mp)
    end
    if not self.visible then
        return
    end
    
    love.graphics.setColor(0,0,0)
    local textX = x + 3
    local textY = y + 3
    local font = love.graphics.getFont()
    if self.justify == 'center' then
        textX = x + self.width/2 - font:getWidth(self.label)/2
    end
    love.graphics.print(self.label,textX,textY)
end

-- Any special behavior for onClick you want this type of button to do before the click
-- For example: a text box might use this because a textbox is just a button when you think about it.
function Button:preOnClick()
end

return Button
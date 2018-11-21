local Vector = require('nx/vector')
local ButtonBase = {}

ButtonBase.font = love.graphics.newFont('fonts/Roboto-Light.woff',14)

-- buttonbase Class
function ButtonBase.new(x,y,onClick)
    local self = newObject(ButtonBase)
    self.pos = Vector.new(x,y)
    self.width = 128
    self.height = 32
    self.justify = 'center'
    self.visible = true

    -- private
    self._wasPressed = false
    self.onClick = onClick
    if self.onClick == nil then
        function self:onClick()
            print('NO BEHAVIOR DEFINED FOR ONCLICK')
        end
    end

    return self
end

function ButtonBase:baseUpdate(dt)
    if not self.visible then
        return
    end
end

function ButtonBase:baseDraw(x,y,mp)
    if not self.visible then
        return
    end

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

    if not love.mouse.isDown(1) then
        if self._wasPressed and hover then
            self:preOnClick()
            self:onClick()
        end
        self._wasPressed = false
    end

    if hover and gClickedThisFrame then
        self._wasPressed = true
    end
end

return ButtonBase
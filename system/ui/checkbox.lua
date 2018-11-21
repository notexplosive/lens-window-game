local Vector = require('nx/vector')
local ButtonBase = require('system/ui/buttonbase')
local State = require('system/state')
local Icons = require('system/icons')

local CheckBox = {}

function CheckBox.new(label,x,y,flagName,persist)
    assert(flagName ~= nil,'Flagname must be supplied to checkbox')
    local self = ButtonBase.new(x,y,onClick)
    self.update = CheckBox.update
    self.draw = CheckBox.draw
    self.preOnClick = CheckBox.preOnClick
    self.onClick = CheckBox.onClick

    self.persist = persist
    self.flagName = flagName
    self.width = 16
    self.height = 16
    self.label = label
    return self
end

function CheckBox:update(dt)
    self:baseUpdate(dt)
end

function CheckBox:draw(x,y,mp)
    if self.baseDraw then
        self:baseDraw(x,y,mp)
    end
    if not self.visible then
        return
    end
    
    if State:get(self.flagName) then
        local image,quad = Icons.getQuad('checkbox')
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(image,quad,x,y)
    end

    love.graphics.setColor(0,0,0,1)
    love.graphics.setFont(ButtonBase.font)
    love.graphics.print(self.label,x + 24,y)
end

function CheckBox:onClick()
    State:set(self.flagName,not State:get(self.flagName))
    -- Save to disk if persist
    if self.persist then
        State:persist(self.flagName,State:get(self.flagName))
    end
end

-- Any special behavior for onClick you want this type of CheckBox to do before the click
-- For example: a text box might use this because a textbox is just a CheckBox when you think about it.
function CheckBox:preOnClick()
end

return CheckBox
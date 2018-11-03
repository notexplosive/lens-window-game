local Vector = require('nx/vector')
local Window = require('system/window')
local AppTemplate = {}

AppTemplate.positions = {}

function AppTemplate.new(name,icon,width,height)
    local self = newObject(AppTemplate)
    self.name = name
    self.width = width
    self.height = height
    function self.update(dt) end
    function self.draw() end
    self.icon = icon

    AppTemplate.positions[name] = Vector.new(love.graphics.getDimensions()) / 2 - Vector.new(self.width/2,self.height/2)

    return self
end

function AppTemplate:spawn(args)
    local w = Window.new(self.name,self.width,self.height)
    w.canvasDraw = self.draw
    w.canvasUpdate = self.update
    w.icon = self.icon
    w.pos = AppTemplate.positions[self.name]:clone()

    if self.textInput then
        w.textInput = self.textInput
    end

    if self.keyPress then
        w.keyPress = self.keyPress
    end

    if self.scroll then
        w.scroll = self.scroll
    end

    --AppTemplate.positions[self.name] = AppTemplate.positions[self.name] + Vector.new(32,32)
    self:onStart(w,args)
    w:bringToFront()
    return w
end

return AppTemplate
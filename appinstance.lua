local Vector = require('nx/vector')
local Window = require('system/window')
local AppInstance = {}

AppInstance.positions = {}

function AppInstance.new(name,icon,width,height,init,loop)
    local self = newObject(AppInstance)
    self.name = name
    self.width = width
    self.height = height
    self.init = init
    self.canvasDraw = loop
    function self.update(dt) end
    self.icon = icon

    AppInstance.positions[name] = Vector.new(love.graphics.getDimensions()) / 2 - Vector.new(self.width/2,self.height/2)

    return self
end

function AppInstance:spawn(args)
    local w = Window.new(self.name,self.width,self.height)
    w.canvasDraw = self.canvasDraw
    w.canvasUpdate = self.update
    w.icon = self.icon
    w.pos = AppInstance.positions[self.name]:clone()

    if self.textInput then
        w.textInput = self.textInput
    end

    if self.keyPress then
        w.keyPress = self.keyPress
    end

    if self.scroll then
        w.scroll = self.scroll
    end

    --AppInstance.positions[self.name] = AppInstance.positions[self.name] + Vector.new(32,32)
    self:init(w,args)
    w:bringToFront()
    return w
end

return AppInstance
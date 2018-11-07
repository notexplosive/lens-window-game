local Vector = require('nx/vector')
local Window = require('system/window')
local AppTemplate = {}

AppTemplate.positions = {}

function AppTemplate.new(name,width,height)
    local self = newObject(AppTemplate)
    self.name = name
    self.width = width or 640
    self.height = height or 480
    function self.onStart() end
    function self.update(dt) end
    function self.draw() end

    AppTemplate.positions[name] = Vector.new(love.graphics.getDimensions()) / 2 - Vector.new(self.width/2,self.height/2)

    return self
end

function AppTemplate:spawn(args)
    local w = Window.new(self.name,self.width,self.height)
    w.canvasDraw = self.draw
    w.canvasUpdate = self.update
    w.icon = self.icon
    w.pos = AppTemplate.positions[self.name]:clone()
    w.enabledControlButtons = self.enabledControlButtons or {true,true,true}
    w.allowResizing = self.allowResizing or true

    if self.textInput then
        w.textInput = self.textInput
    end

    if self.keyPress then
        w.keyPress = self.keyPress
    end

    if self.scroll then
        w.scroll = self.scroll
    end

    if self.onResize then
        w.onResize = self.onResize
    end

    self:onStart(w,args)
    w:bringToFront()
    return w
end

return AppTemplate
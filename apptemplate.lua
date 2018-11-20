local Vector = require('nx/vector')
local Window = require('system/window')
local AppTemplate = {}

AppTemplate.positions = {}

function AppTemplate.new(name,width,height)
    local self = newObject(AppTemplate)
    self.name = name
    self.showOnDesktop = true
    self.width = width or 640
    self.height = height or 480
    self.behavior = {}
    function self.onStart() end
    function self.update(dt) end
    function self.draw() end

    AppTemplate.positions[name] = Vector.new(love.graphics.getDimensions()) / 2 - Vector.new(self.width/2,self.height/2)

    return self
end

function AppTemplate:spawn(args)
    if self.singleton and Window.getOpen(self) then
        local w = Window.getOpen(self)
        w:bringToFront()
        w.visible = true
        return
    end

    AppTemplate.positions[self.name] = AppTemplate.positions[self.name] + Vector.new(10,10)
    local w = Window.new(self.name,self.width,self.height)
    w.canvasDraw = self.draw
    w.canvasUpdate = self.update
    w.icon = self.icon
    w.pos = AppTemplate.positions[self.name]:clone()
    w.enabledControlButtons = {true,true,true}
    w.associatedApp = self

    local injectedPropertiesAndMethods = {
        -- Methods
        'behavior',
        'textInput',
        'keyPress',
        'scroll',
        'onResize',
        'onClose',
        'onStart',

        -- Properties
        'allowResizing',
        'enabledControlButtons',
        'scene',
        'needsFocus',
        'slug'
    }

    for i,prop in ipairs(injectedPropertiesAndMethods) do
        if self[prop] ~= nil then
            w[prop] = self[prop]
        end
    end

    if w.behavior then
        w.behavior.state = w.state
    end

    w:onStart(w,args)
    w:bringToFront()
    return w
end

return AppTemplate
local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

local app = AppTemplate.new('Alert',400,100)
app.icon = 'warning'
app.iconName = 'Alert'
app.allowResizing = false
app.enabledControlButtons = {true,false,false}
app.showOnDesktop = false

local PopUp = app

function PopUp:onStart(window,args)
    love.audio.newSource('sounds/no2.ogg', 'static'):play()
    window.state.label = 'This is a popup'
end

function PopUp:draw(selected,mp)
    local image,quad = Icons.getQuad('warning')
    love.graphics.draw(image,quad,20,20,0,1.5,1.5)
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.state.label,32 + 64,20)
end

function PopUp:keyPress(key,isDesktop)
end

function PopUp:onClose()
end

return PopUp
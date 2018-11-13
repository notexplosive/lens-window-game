local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')
local Timer = require('system/timer')
local State = require('system/state')
local UI = require('system/ui')

local app = AppTemplate.new('Settings',440,480)
app.icon = 'settings'
app.iconName = 'Settings'
app.enabledControlButtons = {true,false,true}
app.allowResizing = false

function logOut()
    State:set('loggingOff',false)
    State:set('isLoggedIn',false)
end

function closeAllWindows()
    for i,window in ipairs(Window.getAll()) do
        Timer.new(math.random(1,10)/10,function() window:close() end)
    end
end

function app:onStart(window,args)
    local leftSide = 16
    local topSide = 64
    self.buttons = {
        UI.button.new('Log Off',leftSide,topSide, function()
            if not State:get('loggingOff') then
                State:set('loggingOff')
                love.audio.newSource('sounds/shutdown.ogg', 'static'):play()
                Timer.new(2,closeAllWindows)
                Timer.new(3,logOut)
            end
        end),
        UI.button.new('Another button',leftSide,topSide + 32),
        UI.checkbox.new('myCoolCheckbox',leftSide,topSide + 64,'myCoolFlag'),
        UI.checkbox.new('Scanline shader',leftSide,topSide + 64 + 24,'shaderEnabled',true),
    }
end

function app:draw(selected,mp)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print('General Settings',16,20)

    for i,button in ipairs(self.buttons) do
        -- This won't work with scrolling I don't think
        button:draw(button.pos.x,button.pos.y,mp)
    end
end

function app:update(dt)
    for i,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function app:keyPress(key,isDesktop)
    
end

return app
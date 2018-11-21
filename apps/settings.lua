local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')
local Timer = require('system/timer')
local State = require('system/state')
local UI = require('system/ui')
local LoginScreen = require('system/loginscreen')

local app = AppTemplate.new('Settings',240,280)
app.icon = 'settings'
app.iconName = 'Settings'
app.enabledControlButtons = {true,false,true}
app.allowResizing = false
app.singleton = true

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
        UI.button.new('Log Out',leftSide,topSide, function()
            if not State:get('loggingOff') then
                State:set('loggingOff')
                love.audio.newSource('sounds/shutdown.ogg', 'static'):play()
                Timer.new(2,closeAllWindows)
                Timer.new(3,logOut)
                LoginScreen.loginInProgress = false
            end
        end),
        UI.button.new('Shut Down',leftSide,topSide + 32, function()
            love.event.quit(0)
        end),
        UI.button.new('Change Wallpaper',leftSide,topSide + 128 - 32, function()
            LaunchApp('explorer','Pictures')
        end),
        UI.checkbox.new('Windowed',leftSide,topSide + 128,'windowed',true),
        UI.checkbox.new('Scanline shader',leftSide,topSide + 128 + 24,'shaderEnabled',true),
        UI.checkbox.new('CRT shader',leftSide,topSide + 128 + 24*2,'CRTshaderEnabled',true)
    }
end

function app:draw(selected,mp)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print('General Settings',16,20)
    love.graphics.print('Graphics',16,128)

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
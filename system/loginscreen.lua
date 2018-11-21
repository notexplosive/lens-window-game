local UI = require('system/ui')
local Vector = require('nx/vector')
local Timer = require('system/timer')
local LoginScreen = {}

LoginScreen.heroFont = love.graphics.newFont('fonts/Roboto.woff',42)
LoginScreen.sideKickFont = love.graphics.newFont('fonts/Roboto-Light.woff',20)
LoginScreen.OSLogo = love.graphics.newImage('images/wonders.png')

function LoginScreen.new()
    local self = newObject(LoginScreen)
    self.UIElements = {
        UI.button.new('Log In',0,0,LoginScreen.logInButtonPress)
    }
    
    return self
end

function LoginScreen:update(dt)
    for i,v in ipairs(self.UIElements) do
        v:update(dt)
    end
end

function LoginScreen:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    love.graphics.setColor(0.5,0.3,0.8)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())
    love.graphics.setColor(0.8,0.8,1)
    love.graphics.line(screenWidth/2,32,screenWidth/2,screenHeight-64)

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(LoginScreen.sideKickFont)
    local subtitle = "Macrolabs"
    local subtitleWidth = LoginScreen.sideKickFont:getWidth(subtitle)
    local subtitleHeight = LoginScreen.sideKickFont:getHeight()
    local subtitleX = screenWidth/2 - subtitleWidth - 128
    local subtitleY = screenHeight/3 + 64 + 32
    local title = "Wonders"

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(LoginScreen.OSLogo, subtitleX + 64 + 16 , subtitleY - 64 - 16 - 8)
    love.graphics.print(subtitle,subtitleX,subtitleY)
    love.graphics.setFont(LoginScreen.heroFont)
    love.graphics.print(title,subtitleX,subtitleY + subtitleHeight)

    local mp = Vector.new(love.mouse.getPosition())
    local UIRoot = Vector.new(screenWidth/2 + 10, screenHeight/2)

    love.graphics.setFont(LoginScreen.sideKickFont)
    love.graphics.print('Welcome back!',UIRoot.x,UIRoot.y - 64)

    for i,v in ipairs(self.UIElements) do
        v.pos = UIRoot:clone() + Vector.new(0,(i-1) * 26)
        v:draw(v.pos.x,v.pos.y,mp)
    end
end

function LoginScreen.logInButtonPress()
    if not LoginScreen.loginInProgress then
        playLoginSound()
        Timer.new(1.5,logIn)
    end
    LoginScreen.loginInProgress = true
end

return LoginScreen
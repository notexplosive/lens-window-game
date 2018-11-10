local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

-- NOTEPAD
local app = AppTemplate.new('TextBoy',400,500)
app.icon = 'textboy'
app.iconName = 'Textboy'
app.behavior = {}

-- window == self??
function app:onStart(window,args)
    window.state.storedText = nil
    if args ~= nil then
        local filename = args:split('/')[#args:split('/')]
        window.title = window.title .. ' - ' .. filename
        self.readOnly = true
        
        -- Force size change if title is too long
        if window.width < Window.OSFont:getWidth(window.title) + 256 then
            window.width = Window.OSFont:getWidth(window.title) + 256
        end

        local temp = love.filesystem.read('files/'..args)
        window.state.path = 'files/'..args
        local text = app.behavior.reloadText(window)
        window.state.text = text
    else
        window.state.text = ''
    end

    window.state.frame = 0
end

function app.behavior.reloadText(self)
    if self.state.storedText then
        return self.state.storedText
    end
    
    if self.state.path then
        local temp = love.filesystem.read(self.state.path)
        self.state.text = calcLineBreaks(temp, self.width,Window.OSFont)
        self.state.storedText = self.state.text
        self.behavior.recalcBottomContentY(self)
        return self.state.text
    end

    return ''
end

function app:draw(selected)
    self.state.frame = self.state.frame + 1
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill', 1, 1, w-2, h-2)
    love.graphics.setColor(0,0,0,1)

    local text = self.state.text
    if math.sin(self.state.frame / 10) > 0 and selected then
        text = text .. '|'
    end
    
    love.graphics.print(text,2,2 + self.scrollY)
end

function app:scroll(dy)
    if -self.bottomContentY > self.canvas:getHeight() then
        self.scrollY = self.scrollY + dy * gScrollIncrement
        if self.scrollY > 0 then
            self.scrollY = 0
        end

        if self.scrollY < self.bottomContentY + self.canvas:getHeight() then
            self.scrollY = self.bottomContentY + self.canvas:getHeight()
        end
    end
end

function app:textInput(text)
    local fullText = self.state.text
    fullText = fullText .. ' '
    if text ~= ' ' then

    end
end

function app:keyPress(key)
    self.state.frame = 0
    if key == 'return' then
        self.state.text = self.state.text .. '\n'
    end

    if key == 'backspace' then
        self.state.text = self.state.text:sub(1, -2)
    end
end

function app:onResize()
    self.state.text = calcLineBreaks(app.behavior.reloadText(self),self.width,Window.OSFont)
    self.behavior.recalcBottomContentY(self)
end

function app.behavior.recalcBottomContentY(self)
    local _,count = self.state.text:gsub('\n','\n')
    count = count + 1
    self.bottomContentY = -count * Window.OSFont:getHeight()
end

return app
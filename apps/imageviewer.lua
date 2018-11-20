local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')
local UI = require('system/ui')

local app = AppTemplate.new('Image Looker',600,600)
app.icon = 'image'
app.iconName = 'Image Viewer'
app.allowResizing = false
app.enabledControlButtons = {true,false,false}
app.showOnDesktop = false

local ImageViewer = app

function ImageViewer:onStart(window,args)
    if args then
        local path = 'files/' .. args
        self.path = path
        self.state.image = love.graphics.newImage(path)
        self.scale = 1
        if self.state.image:getWidth() > 600 then
            self.scale = 0.5
        end
        self.width = self.state.image:getWidth() * self.scale
        self.height = self.state.image:getHeight() * self.scale
    end

    self.setBGButton = UI.button.new('Set as background',leftSide,topSide, function()
        State:persist("background",self.path)
    end)
end

function ImageViewer:draw(selected,mp)
    if self.state.image then
        love.graphics.draw(self.state.image,0,0,0,self.scale,self.scale)
    end
    self.setBGButton:draw(self.setBGButton.pos.x,self.setBGButton.pos.y,mp)
end

function ImageViewer:keyPress(key,isDesktop)
end

function ImageViewer:onClose()
end

return ImageViewer
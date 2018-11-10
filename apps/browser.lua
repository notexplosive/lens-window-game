local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

local app = AppTemplate.new('NetScrape Navigator')
app.icon = 'internet'
app.iconName = 'NetScrape'

local Browser = app

function Browser:onStart(window,args)
    self.spawnTimer = 1
end

function Browser:draw(selected,mp)
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill',1,1,w-2,h-2)
    love.graphics.setColor(0,0,0)
    love.graphics.print('Connecting to information superhighway...')
end

function Browser:update(dt)
    if self.spawnTimer > 0 then
        self.spawnTimer = self.spawnTimer - dt
        if self.spawnTimer < 0 then
            self:spawnChild('popup').title = 'NetScrape Error'
        end
    end
end

function Browser:keyPress(key,isDesktop)
    
end

return Browser
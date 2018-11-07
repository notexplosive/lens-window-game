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
end

function Browser:draw(selected,mp)
    love.graphics.circle('line', mp.x, mp.y, 10)
end

function Browser:keyPress(key,isDesktop)
end

return Browser
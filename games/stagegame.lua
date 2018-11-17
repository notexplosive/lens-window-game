local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')

local app = GameTemplate.new('Stage')
app.icon = 'shell'
app.iconName = 'Stage'

function app:onStart(window,args)
    --self.scene = Scene.new(window.canvas:getDimensions())
end

function app:keyPress(key,isDesktop)
    
end

return app
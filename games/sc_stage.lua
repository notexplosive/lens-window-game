local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')

local app = GameTemplate.new('Stage')
app.icon = 'app'
app.iconName = 'Stage'
-- DELETE THIS LINE IF USING TEMPLATE
app.showInGames = false

function app:onStart(window,args)
    
end

function app:keyPress(key,isDesktop)
    
end

return app
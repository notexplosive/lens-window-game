local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')

local Actor = require('nx/game/actor')
local TargetBehavior = require('components/target')
local SpriteRenderer = require('nx/game/components/spriterenderer')

local app = GameTemplate.new('Target',256,256)
app.icon = 'app'
app.iconName = 'Target'

function app:onStart(window,args)
    local target = Actor.new('Target')
    target:addComponent(SpriteRenderer)
    target.spriteRenderer:setSprite(Assets.target)
    target.pos = Vector.new(128,128)
    
    target:addComponent(TargetBehavior)
    
    self.scene:addActor(
        target
    )
end

function app:keyPress(key,isDesktop)
    
end

return app
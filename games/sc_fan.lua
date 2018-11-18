local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')
local Actor = require('nx/game/actor')

local ForceZone = require('components/forcezone')
local SpriteRenderer = require('nx/game/components/spriterenderer')

local app = GameTemplate.new('Fan',200,400)
app.icon = 'app'
app.iconName = 'Fan'

function app:onStart(window,args)
    local fan = Actor.new('Fan')
    local force = Actor.new('ForceZone')

    fan:addComponent(SpriteRenderer)
    fan.spriteRenderer:setSprite(Assets.fan)
    fan.spriteRenderer.fps = 15
    fan.spriteRenderer:setAnimation('all')
    fan.pos = Vector.new(100,400-32)

    force:addComponent(ForceZone)
    force.pos = Vector.new(20,180)
    force.forceZoneBehavior.width = 160
    force.forceZoneBehavior.height = 200

    self.scene:addActor(
        fan,
        force
    )
end

function app:keyPress(key,isDesktop)
    
end

return app
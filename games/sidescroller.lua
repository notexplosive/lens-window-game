local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')

local Actor = require('nx/game/actor')
local PlatformerComponent = require('components/platformer')
local SpriteRenderer = require('nx/game/components/spriterenderer')

local app = GameTemplate.new('Side Scroller')
app.icon = 'shell'
app.iconName = 'Side Scroller'

function app:onStart(window,args)
    self.scene = Scene.new()
    local act = Actor.new('Foobar')

    act:addComponent(SpriteRenderer):setSprite(Assets.swordBoy)
    act.spriteRenderer.scale = 2
    act:addComponent(PlatformerComponent)

    act.pos = Vector.new(200,200)

    self.scene:addActor(
        act
    )
end

function app:keyPress(key,isDesktop)
    
end

return app
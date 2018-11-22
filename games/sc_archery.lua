local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')

local Actor = require('nx/game/actor')
local ArcheryHandle = require('components/archeryhandle')
local SpriteRenderer = require('nx/game/components/spriterenderer')

local app = GameTemplate.new('Archery Practice',364,128)
app.icon = 'app'
app.iconName = 'Archery'

function app:onStart(window,args)
    local drawstring = Actor.new('Drawstring')
    local bow = Actor.new('Bow')

    bow:addComponent(SpriteRenderer)
    bow.spriteRenderer:setSprite(Assets.bow)

    drawstring:addComponent(ArcheryHandle)

    bow.pos = drawstring.archeryHandle.originalPos:clone()

    self.scene:addActor(
        drawstring,
        bow
    )
end

function app:keyPress(key,isDesktop)
    
end

return app
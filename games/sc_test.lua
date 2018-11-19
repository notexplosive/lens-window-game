local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')
local Actor = require('nx/game/actor')

local SpriteRenderer = require('nx/game/components/spriterenderer')
local TurretBehavior = require('components/turret')

local app = GameTemplate.new('Lens Test',250,250)
app.icon = 'app'
app.iconName = 'Lens Test'
-- app.showInGames = false

function app:onStart(window,args)
    local turret = Actor.new('Turret')
    
    turret.pos = Vector.new(125,125)
    turret:addComponent(TurretBehavior)

    self.scene:addActor(
        turret
    )

    for i=1,128 do
        self:update(1/60)
    end
end

function app:keyPress(key,isDesktop)
    
end

return app
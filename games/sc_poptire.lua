local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')
local Actor = require('nx/game/actor')

local PaddleMovementBehavior = require('components/paddlemovement')
local SimplePhysics = require('components/simplephysics')
local SimpleCollider = require('components/simplecollider')
local BoxCollider = require('components/boxcollider')
local EmptyRenderer = require('nx/game/components/emptyrenderer')
local PopTireBehavior = require('components/poptire')

local app = GameTemplate.new('Poptire',640,480)
app.icon = 'app'
app.iconName = 'Poptire'
-- app.showInGames = false

function app:onStart(window,args)
    local ball = Actor.new('Tire',true)

    ball.pos = Vector.new(self.width/2,self.height/2)
    ball:addComponent(SimpleCollider).radius = 48
    ball:addComponent(EmptyRenderer).draw = function(self,x,y)
        if self.actor.scene then
            love.graphics.setColor(0,0,0,0.2)
            love.graphics.ellipse('fill',x,self.actor.scene.height,self.actor.simpleCollider.radius,self.actor.simpleCollider.radius/2)
        end
        love.graphics.setColor(.3,0,0,1)
        love.graphics.circle('fill',x,y,self.actor.simpleCollider.radius+2)
        love.graphics.setColor(1,0.2,0.2,1)
        love.graphics.circle('fill',x,y,self.actor.simpleCollider.radius)
        love.graphics.setColor(1,1,1)
        local text = self.actor.popTire.score
        if self.actor.popTire.cooldown > 0 then
            text = self.actor.popTire.cooldown
        end
        love.graphics.print( math.ceil(text),x-6,math.floor(y-love.graphics.getFont():getHeight()/2))
    end

    ball:addComponent(SimplePhysics).onHitEdge = function(self,left,right,top,bottom)
        -- do nothing
    end
    ball:addComponent(PopTireBehavior)

    self.scene:addActor(
        ball
    )
end

function app:keyPress(key,isDesktop)
    
end

function app:draw()
    
end

function app:update(dt)
    
end

return app
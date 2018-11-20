local Vector = require('nx/vector')
local TurretBehavior = {}

local Actor = require('nx/game/actor')
local SimplePhysics = require('components/simplephysics')
local EmptyRenderer = require('nx/game/components/emptyrenderer')

TurretBehavior.name = 'turretBehavior'

function TurretBehavior.create()
    return newObject(TurretBehavior)
end

function TurretBehavior:awake()
    self.time = 0
end

function TurretBehavior:draw()
    love.graphics.setColor(1,0.3,0)
    love.graphics.circle('fill',self.actor.pos.x,self.actor.pos.y,30)
end

function TurretBehavior:update(dt)
    self.time = self.time + dt
    if self.time > 0.1 then
        self.time = 0
        local bullet = Actor.new('Bullet',true)
        bullet.pos = self.actor.pos:clone()
        local phy = bullet:addComponent(SimplePhysics)
        phy.velocity = Vector.new(3,3)
        phy.onHitEdge = function(self)
            self.actor:destroy()
        end
        bullet:addComponent(EmptyRenderer).draw = function(self,x,y)
            love.graphics.setColor(1,0.3,0)
            love.graphics.circle('fill',x,y,20)
        end

        self.actor.scene:addActor(bullet)
    end
end

return TurretBehavior
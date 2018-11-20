local Vector = require('nx/vector')
local SimpleCollider = require('components/simplecollider')
local SimplePhysics = require('components/simplephysics')
local Arrow = {}

Arrow.name = 'arrowBehavior'

function Arrow.create()
    return newObject(Arrow)
end

function Arrow:awake()
    self.actor:addComponent(SimpleCollider)
    local phys = self.actor:addComponent(SimplePhysics)
    phys.onHitEdge = function(self,left,right,top,bottom)
        if not top then
            self.actor:destroy()
        end
    end
end

function Arrow:update(dt)
    self.actor.simplePhysics.velocity.y = self.actor.simplePhysics.velocity.y + dt*32

    local normal = self.actor.simplePhysics.velocity:normalized()
    self.actor.spriteRenderer.angle = math.atan(normal.y,normal.x)
    
    if normal.x < 0 then
        self.actor.spriteRenderer.angle = -self.actor.spriteRenderer.angle + math.pi
    end

    if math.abs(normal.x) < math.abs(normal.y) then
        if normal.y > 0 then
            self.actor.spriteRenderer.angle = self.actor.spriteRenderer.angle + math.pi/4
        end

        if normal.y < 0 then
            self.actor.spriteRenderer.angle = self.actor.spriteRenderer.angle - math.pi/4
        end
    end

    -- if self.actor.scene then
    --     if self.actor.pos.x > self.actor.scene.width or self.actor.pos.y > self.actor.scene.height then
    --         self.actor:destroy()
    --     end
    -- end
end

return Arrow
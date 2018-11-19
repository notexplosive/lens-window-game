local Vector = require('nx/vector')
local SimplePhysics = {}

SimplePhysics.name = 'simplePhysics'

function SimplePhysics.create()
    return newObject(SimplePhysics)
end

function SimplePhysics:awake()
    self.velocity = Vector.new(0,0)
end

function SimplePhysics:update(dt)
    local newPos = self.actor.pos + self.velocity

    if self.actor.collider and not self.actor.collider.collidedThisFrame or not self.actor.collider then
        self.actor.pos = newPos
    end

    if self.actor.scene then
        local px,x1,x2 = clamp(self.actor.pos.x,0,self.actor.scene.width)
        local py,y1,y2 = clamp(self.actor.pos.y,0,self.actor.scene.height)

        -- this might mess with collision because pos was just definitively assigned
        self.actor.pos = Vector.new(px,py)

        if x1 or x2 or y1 or y2 then
            self:onHitEdge()
        end
    end
end

-- default
function SimplePhysics:onHitEdge()
    self.actor:destroy()
end

return SimplePhysics
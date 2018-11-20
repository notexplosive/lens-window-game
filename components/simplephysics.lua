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
    local collided = false

    --if self.actor.collider and not self.actor.collider.collidedThisFrame or not self.actor.collider then
        self.actor.pos = newPos
        --collided = true
    --end

    if self.actor.scene then
        local px,left,right = clamp(self.actor.pos.x,0,self.actor.scene.width)
        local py,top,bottom = clamp(self.actor.pos.y,0,self.actor.scene.height)

        -- this might mess with collision because pos was just definitively assigned
        if not collided then
            --self.actor.pos = Vector.new(px,py)
        end

        if left or right or top or bottom then
            self:onHitEdge(left,right,top,bottom)
        end
    end
end

-- default
function SimplePhysics:onHitEdge(left,right,top,bottom)
    self.velocity = Vector.new(0,0)
    if left then self.actor.pos.x = 0 end
    if right then self.actor.pos.x = self.actor.scene.width end
    if bottom then self.actor.pos.y = self.actor.scene.height end
    if top then self.actor.pos.y = 0 end
    --self.actor:destroy()
end

return SimplePhysics
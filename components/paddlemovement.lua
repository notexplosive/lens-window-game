local BoxCollider = require('components/boxcollider')
local Vector = require('nx/vector')
local PaddleMovementBehavior = {}

PaddleMovementBehavior.name = 'paddleMovementBehavior'

function PaddleMovementBehavior.create()
    return newObject(PaddleMovementBehavior)
end

function PaddleMovementBehavior:awake()
    self.inputY = 0
    self.width = 16
    self.height = 64
    self.speed = 256
end

function PaddleMovementBehavior:draw()

end

function PaddleMovementBehavior:update(dt)
    if self.boxCollider == nil then
        local collider = self.actor:addComponent(BoxCollider)
        collider.width = self.width
        collider.height = self.height
        collider.offset = -Vector.new(self.width/2,self.height/2)
        
        collider.onCollide = function(self,otherCollider)
            self.collidedThisFrame = true
            if otherCollider.actor.simplePhysics then
                otherCollider.actor.simplePhysics.velocity.x = -otherCollider.actor.simplePhysics.velocity.x
            end
        end
    end

    local newPos = self.actor.pos + Vector.new(0,self.inputY)

    if self.actor.scene then
        newPos.y = clamp(newPos.y,self.height/2,self.actor.scene.height - self.height/2)
    end
    
    self.actor.pos = newPos
end

return PaddleMovementBehavior
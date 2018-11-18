local Vector = require('nx/vector')
local Arrow = {}

Arrow.name = 'arrowBehavior'

function Arrow.create()
    return newObject(Arrow)
end

function Arrow:awake()
    self.velocity = Vector.new(0,0)
end

function Arrow:draw()
    
end

function Arrow:update(dt)
    local tempPos = self.actor.pos + self.velocity * dt
    self.velocity.y = self.velocity.y + 500 * dt
    self.actor.pos = tempPos

    self.actor.spriteRenderer.angle = math.sin(self.velocity.y/500)

    if self.actor.scene then
        if self.actor.pos.x > self.actor.scene.width or self.actor.pos.y > self.actor.scene.height then
            self.actor:destroy()
        end
    end
end

return Arrow
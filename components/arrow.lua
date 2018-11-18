local Vector = require('nx/vector')
local Arrow = {}

Arrow.name = 'arrowBehavior'

function Arrow.create()
    return newObject(Arrow)
end

function Arrow:awake()
    print('arrow spawned')
    self.velocity = Vector.new(0,0)
end

function Arrow:draw()
    
end

function Arrow:update(dt)
    local tempPos = self.actor.pos + self.velocity * dt
    self.velocity.y = self.velocity.y + 200 * dt
    self.actor.pos = tempPos
end

return Arrow
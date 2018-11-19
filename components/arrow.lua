local Vector = require('nx/vector')
local SimpleCollider = require('components/simplecollider')
local Arrow = {}

Arrow.name = 'arrowBehavior'

function Arrow.create()
    return newObject(Arrow)
end

function Arrow:awake()
    self.velocity = Vector.new(0,0)
    self.actor:addComponent(SimpleCollider)
end

function Arrow:draw()
    
end

function Arrow:update(dt)
    local tempPos = self.actor.pos + self.velocity * dt
    self.velocity.y = self.velocity.y + 500 * dt
    self.actor.pos = tempPos

    local normal = self.velocity:normalized()
    self.actor.spriteRenderer.angle = math.atan(normal.y,normal.x)
    if math.abs(normal.x) < math.abs(normal.y) then
        if normal.y > 0 then
            self.actor.spriteRenderer.angle = self.actor.spriteRenderer.angle + math.pi/4
        end

        if normal.y < 0 then
            self.actor.spriteRenderer.angle = self.actor.spriteRenderer.angle - math.pi/4
        end
    end

    if self.actor.scene then
        if self.actor.pos.x > self.actor.scene.width or self.actor.pos.y > self.actor.scene.height then
            self.actor:destroy()
        end
    end
end

return Arrow
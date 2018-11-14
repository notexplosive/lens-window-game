local Vector = require('nx/vector')
local PlatformerBehavior = {}

PlatformerBehavior.name = 'platformerBehavior'

function PlatformerBehavior.create()
    return newObject(PlatformerBehavior)
end

function PlatformerBehavior:awake()
    self.speed = 2
end

function PlatformerBehavior:draw()
    
end

function PlatformerBehavior:update(dt)
    local velocity = Vector.new()
    if love.keyboard.isDown('left') then
        self.actor.spriteRenderer:setFlipX(true)
        velocity.x = velocity.x - 1 * self.speed
    end
    if love.keyboard.isDown('right') then
        self.actor.spriteRenderer:setFlipX(false)
        velocity.x = velocity.x + 1 * self.speed
    end

    if velocity.y == 0 then
        if math.abs(velocity.x) > 0 then
            self.actor.spriteRenderer:setAnimation('run')
        else
            self.actor.spriteRenderer:setAnimation('stop')
        end
    end

    self.actor:move(velocity)
end

return PlatformerBehavior
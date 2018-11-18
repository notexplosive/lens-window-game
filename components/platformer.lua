local Vector = require('nx/vector')
local PlatformerBehavior = {}

PlatformerBehavior.name = 'platformerBehavior'

function PlatformerBehavior.create()
    return newObject(PlatformerBehavior)
end

function PlatformerBehavior:awake()
    self.speed = 4
    self.velocity = Vector.new(0,0)
end

-- Might use this for debugging
function PlatformerBehavior:draw()

end

function PlatformerBehavior:update(dt)
    -- Gravity
    self.velocity.y = self.velocity.y + 1

    local inputX = 0
    if love.keyboard.isDown('left') then
        self.actor.spriteRenderer:setFlipX(true)
        inputX = inputX - 1 * self.speed
    end
    if love.keyboard.isDown('right') then
        self.actor.spriteRenderer:setFlipX(false)
        inputX = inputX + 1 * self.speed
    end

    inputX = clamp(inputX,-self.speed,self.speed)

    self.velocity.x = inputX

    local newPos,collideTop,collideBottom,collideLeft,collideRight = self:handleCollisions()

    self.actor.pos = newPos

    if love.keyboard.isDown('up') and collideBottom then
        self.velocity.y = -10
    end

    if collideBottom then
        if math.abs(self.velocity.x) > 0 then
            self.actor.spriteRenderer:setAnimation('run')
        else
            self.actor.spriteRenderer:setAnimation('stop')
        end
    elseif self.velocity.y > 0 then
        self.actor.spriteRenderer:setAnimation('fall')
    else
        self.actor.spriteRenderer:setAnimation('jump')
    end
end

function PlatformerBehavior:handleCollisions()
    if self.actor.scene then
        local newPos = Vector.new(0,0)

        local _,alreadyCollidedLeft,alreadyCollidedRight = clamp(self.actor.pos.x,0,self.actor.scene.width)
        local _,alreadyCollidedTop,alreadyCollidedBottom = clamp(self.actor.pos.y,0,self.actor.scene.height-32)

        local collideBottom,collideTop,collideLeft,collideRight
        newPos.x,collideLeft,collideRight = clamp(self.actor.pos.x + self.velocity.x,0,self.actor.scene.width)
        newPos.y,collideTop,collideBottom = clamp(self.actor.pos.y + self.velocity.y,0,self.actor.scene.height-32)

        if collideTop or collideBottom then
            self.velocity.y = 0
        end

        return newPos,
            collideTop,
            collideBottom,
            collideLeft,
            collideRight
    end

    return self.actor.pos + self.velocity,false,false,false,false
end

return PlatformerBehavior
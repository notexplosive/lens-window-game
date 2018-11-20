local Vector = require('nx/vector')
local State = require('system/state')
local Poptire = {}

Poptire.name = 'popTire'

function Poptire.create()
    return newObject(Poptire)
end

function Poptire:awake()
    self.actor.simplePhysics.velocity = Vector.new(0,10)
    self.originalPosition = self.actor.pos:clone()
    self.cooldown = 3
    self.score = 0
    self.startRadius = self.actor.simpleCollider.radius

    self.actor.simpleCollider.onCollide = function(self,otherBody)
        if otherBody.actor.name == 'Arrow' then
            local newPos = self.actor.pos +
                ((otherBody.actor.pos - self.actor.pos):normalized()
                * (self.radius + otherBody.radius))
            otherBody.actor.pos = newPos
            otherBody.actor.simplePhysics.velocity = -otherBody.actor.simplePhysics.velocity
            self.actor.simplePhysics.velocity.y = 32
        end
    end

    self.sound = love.audio.newSource('sounds/pingpong.ogg', 'static')
end

function Poptire:draw()
    if self.actor.scene then
        local mp = Vector.new(love.mouse.getPosition()) - self.actor.scene.window.pos - Vector.new(0,32)
        --love.graphics.circle('fill', mp.x, mp.y, 20)
    end
end

function Poptire:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
        self.actor.simplePhysics.velocity = Vector.new(0,0)
        return
    end

    self.sound:setPitch( 2 - self.actor.simpleCollider.radius/self.startRadius )

    local mp = Vector.new(love.mouse.getPosition())
    if self.actor.scene then
        mp = Vector.new(love.mouse.getPosition()) - self.actor.scene.window.pos - Vector.new(0,32)
        local fixedX,hitLeft,hitRight = clamp(self.actor.pos.x,self.actor.simpleCollider.radius,self.actor.scene.width - self.actor.simpleCollider.radius)
        if hitLeft or hitRight and math.abs(self.actor.simplePhysics.velocity.x) > 1 then
            self.sound:play()
            if hitLeft then
                self.actor.simplePhysics.velocity.x = math.abs(self.actor.simplePhysics.velocity.x)/2
            end

            if hitRight then
                self.actor.simplePhysics.velocity.x = -math.abs(self.actor.simplePhysics.velocity.x)/2
            end
        end

        if self.actor.pos.y > self.actor.scene.height - self.actor.simpleCollider.radius then
            self.actor.simplePhysics.velocity.x = self.actor.simplePhysics.velocity.x/8
            self.actor.simplePhysics.velocity.y = -math.abs(self.actor.simplePhysics.velocity.y/2)
            self.actor.pos.y = self.actor.scene.height - self.actor.simpleCollider.radius

            if math.abs(self.actor.simplePhysics.velocity.y) < 2 then
                self.actor.simplePhysics.velocity.y = 0
            else
                self.sound:play()
            end
            self.actor.popTire:resetScore()
        end
    end

    if (mp - self.actor.pos):length() < self.actor.simpleCollider.radius then
        if not self.hover then
            self.sound:play()
            self.hover = true
            self.score = self.score + 1
            self.actor.simpleCollider.radius = self.actor.simpleCollider.radius - 1

            local push = (mp - self.actor.pos):normalized()*10
            push.y = -16
            push.x = -push.x / 5
            self.actor.simplePhysics.velocity.x = self.actor.simplePhysics.velocity.x + push.x
            self.actor.simplePhysics.velocity.y = push.y
        end
    else
        self.hover = false
    end

    self.actor.simplePhysics.velocity = self.actor.simplePhysics.velocity + Vector.new(0,dt) * 40

    if self.score >= 20 then
        self.actor:destroy()
        -- drop key
    end
end

function Poptire:resetScore()
    self.score = 0
    self.actor.simpleCollider.radius = self.startRadius
    -- display score/new record/etc
end

return Poptire
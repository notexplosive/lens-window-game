local Vector = require('nx/vector')
local ForceZone = {}

ForceZone.name = 'forceZoneBehavior'

function ForceZone.create()
    return newObject(ForceZone)
end

function ForceZone:awake()
    self.width = 32
    self.height = 32
    self.force = Vector.new(0,-10)
    self.particles = nil
end

function ForceZone:draw()
    love.graphics.setColor(0,0,1)

    for i,part in ipairs(self.particles) do
        love.graphics.rectangle('fill',self.actor.pos.x + part.x-1,self.actor.pos.y + part.y-1,4,4)
        part.y = part.y - i - 2
        if part.y < 0 then
            part.y = self.height
            part.x = math.random(0,self.width)
        end
    end
end

function ForceZone:update(dt)
    if self.particles == nil then
        self.particles = {
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height)),
            Vector.new(math.random(0,self.width),math.random(0,self.height))
        }
    end

    local allActors = self.actor.scene:getAllActors()

    for i,actor in ipairs(allActors) do
        if isWithinBox(actor.pos.x,actor.pos.y,self.actor.pos.x,self.actor.pos.y,self.width,self.height) then
            if actor.arrowBehavior then
                local distance = (actor.pos - self.actor.pos):length()
                actor.arrowBehavior.velocity.x = actor.arrowBehavior.velocity.x * 0.5
                actor.arrowBehavior.velocity.y = actor.arrowBehavior.velocity.y - 50
            end

            if actor.simplePhysics then
                actor.simplePhysics.velocity.y = actor.simplePhysics.velocity.y - 5
            end
        end
    end
end

return ForceZone
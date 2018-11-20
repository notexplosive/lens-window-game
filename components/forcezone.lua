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

    local hasAtLeastOneActor = false

    for i,actor in ipairs(allActors) do
        if isWithinBox(actor.pos.x,actor.pos.y,self.actor.pos.x,self.actor.pos.y,self.width,self.height) then
            if actor.simplePhysics then
                hasAtLeastOneActor = true
                actor.simplePhysics.velocity.y = actor.simplePhysics.velocity.y - 5

                if actor.name == 'Arrow' then
                    -- arrows get more push
                    actor.simplePhysics.velocity.x = actor.simplePhysics.velocity.x/2
                    actor.simplePhysics.velocity.y = actor.simplePhysics.velocity.y - 5
                end
            end
        end
    end

    if hasAtLeastOneActor then
        -- play sound?
    else
        -- stop sound?
    end
end

return ForceZone
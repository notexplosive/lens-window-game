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
    self.actor.pos = self.actor.pos + self.velocity

    if self.actor.scene then
        local _,x1,x2 = clamp(self.actor.pos.x,0,self.actor.scene.width)
        local _,y1,y2 = clamp(self.actor.pos.y,0,self.actor.scene.height)

        if x1 or x2 or y1 or y2 then
            self.actor:destroy()
        end
    end
end

return SimplePhysics
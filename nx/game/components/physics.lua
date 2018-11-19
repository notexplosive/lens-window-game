local Vector = require('nx/vector')
local Physics = {}

Physics.name = 'physics'

function Physics.create()
    return newObject(Physics)
end

function Physics:awake()
    self.velocity = Vector.new(0,0)
    self.body = nil
end

function Physics:draw()
    if self.body.draw then
        self.body:draw()
    end
end

function Physics:update(dt)
    local newPos = self.pos + self.velocity

    local actor,info = self.body:checkCollidesAt(newPos)
    if actor == nil then
        self.pos = newPos
    else
        self.body:reactToCollide(actor,info)
    end
end

function Physics:setBody(body)
    assert(body.checkCollidesAt,'Body must have a checkCollidesAt function')
    assert(body.reactToCollide,'Body must have a reactToCollide function')
    self.body = body
    self.body.actor = self.actor
end

-- Global functions
function Physics.collide(body1,body2)

end

return Physics
local CircleBody = {}

function CircleBody.create(radius)
    local self = newObject(CircleBody)
    assert(radius,'Circle body must have a radius')
    self.radius = radius
    return self
end

function CircleBody:draw()
    love.graphics.setColor(0,1,0)
    love.graphics.circle('line',self.actor.x,self.actor.y,self.radius)
end

function CircleBody:checkCollidesAt(newPos)
    local actor = nil
    return actor,info
end

function CircleBody:reactToCollide(actor,info)

end

return CircleBody
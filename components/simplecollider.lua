local SimpleCollider = {}

SimpleCollider.name = 'simpleCollider'

function SimpleCollider.create()
    return newObject(SimpleCollider)
end

function SimpleCollider:awake()
    self.radius = 16
end

function SimpleCollider:draw()
    
end

function SimpleCollider:update(dt)
    if self.actor.scene then
        for i,actor in ipairs(self.actor.scene:getAllActors()) do
            if actor ~= self.actor and actor.simpleCollider then
                local distance = (actor.pos - self.actor.pos):length()
                if distance < self.radius + actor.simpleCollider.radius then
                    self:onCollide(actor.simpleCollider)
                end
            end
        end
    end
end

function onCollide(otherCollider)
    -- To be overridden by client code
end

return SimpleCollider
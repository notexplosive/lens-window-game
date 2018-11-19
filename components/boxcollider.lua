local Vector = require('nx/vector')
local BoxCollider = {}

BoxCollider.name = 'boxCollider'

function BoxCollider.create()
    return newObject(BoxCollider)
end

function BoxCollider:awake()
    self.actor.collider = self
    self.width = 32
    self.height = 32
    self.offset = Vector.new()
end

function BoxCollider:draw()
    love.graphics.setColor(0,1,0)
    --love.graphics.rectangle('line',self:getCollisionBox())
end

function BoxCollider:update(dt)
    self.collidedThisFrame = false
    if self.actor.scene then
        for i,actor in ipairs(self.actor.scene:getAllActors()) do
            if actor ~= self.actor and actor.collider then
                -- Default case for calling onCollide
                if isWithinBox(actor.pos.x,actor.pos.y,self:getCollisionBox()) then
                    self:onCollide(actor.simpleCollider)
                    self.collidedThisFrame = true
                end
            end
        end
    end
end

function BoxCollider:onCollide(otherCollider)
    -- To be overridden by client code
end

function BoxCollider:getCollisionBox()
    return self.actor.pos.x + self.offset.x,
        self.actor.pos.y + self.offset.y,
        self.width,
        self.height
end

return BoxCollider
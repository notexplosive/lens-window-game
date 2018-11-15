local Vector = require('nx/vector')
local Actor = {}

function Actor.new(name,star)
    assert(name ~= nil,"Must provide a name for actor")
    local self = newObject(Actor)
    self.name = name
    self.pos = Vector.new()
    self.components = {}
    self.scene = nil
    self.originalScene = nil
    self.star = star or false
    return self
end

-- called by scene
function Actor:sceneUpdate(dt)
    for i,component in ipairs(self.components) do
        if component.update then
            component:update(dt)
        end
    end
end

-- called by scene
function Actor:draw(x,y)
    if x == nil then
        x,y = self.pos.x,self.pos.y
    end
    for i,component in ipairs(self.components) do
        if component.draw then
            component:draw(x,y)
        end
    end
end

-- called by scene OR by others
function Actor:destroy()
    self:onDestroy()
    self:removeFromScene()
end

-- called by lens, doesn't technically "destroy" the actor
function Actor:removeFromScene()
    if self.scene then
        local index = self.scene:getActorIndex(self)
        self.scene.actors[index] = nx_null
        for i = index, #self.scene.actors do
            self.scene.actors[i] = self.scene.actors[i+1]
        end
        self.scene = nil
    end
end

-- a component is anything that has a draw function OR and update function
function Actor:addComponent(componentClass)
    assert(componentClass.name,"Component needs a name")
    assert(componentClass.update or componentClass.draw,componentClass.name .. ' does not have update or draw')
    local component = componentClass.create()
    component.actor = self

    self[component.name] = component

    if component.awake then
        component:awake()
    end
    
    append(self.components,component)

    return component
end

function Actor:move(velocity)
    assert(velocity.type == Vector)
    self.pos = self.pos + velocity
end

return Actor
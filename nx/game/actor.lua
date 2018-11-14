local Vector = require('nx/vector')
local Actor = {}

function Actor.new(name)
    assert(name ~= nil,"Must provide a name for actor")
    local self = newObject(Actor)
    self.name = name
    self.pos = Vector.new()
    self.components = {}
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
function Actor:draw()
    for i,component in ipairs(self.components) do
        if component.draw then
            component:draw()
        end
    end
end

-- called by scene OR by others
function Actor:destroy()
    self:onDestroy()

    if self.scene then
        local index = self.scene:getActorIndex(self)
        self.scene.actors[index] = nx_null
        for i = index, #self.scene.actors do
            self.scene.actors[i] = self.scene.actors[i+1]
        end
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

    return self
end

function Actor:move(velocity)
    assert(velocity.type == Vector)
    self.pos = self.pos + velocity
end

return Actor
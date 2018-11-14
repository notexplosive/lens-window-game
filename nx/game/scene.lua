local Actor = require('nx/game/actor')
local Scene = {}

function Scene.new()
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = {}
    return self
end

function Scene:update(dt)
    for i,actor in ipairs(self.actors) do
        actor:sceneUpdate(dt)
    end
end

function Scene:draw(x,y)
    for i,actor in ipairs(self.actors) do
        actor:draw()
    end

    local names = ''
    for i,v in ipairs(self.actors) do
        names = names .. '[' .. v.name .. '] '
    end
end

-- Add actor to list
function Scene:addActor(actor, ...)
    assert(actor ~= nil,"Scene:addActor must take at least one argument")
    assert(actor.type == Actor,"Can't add a non-actor to a scene")

    actor.scene = self
    append(self.actors,actor)

    if ... then
        for i,v in ipairs({...}) do
            self:addActor(v)
        end
    end
end

-- Get actor by name
function Scene:getActor(actorName)
    assert(actorName)
    for i,actor in ipairs(self.actors) do
        if actor.name == actorName then
            return actor,i
        end
    end

    return nil
end

-- Get index of actor in actor list
function Scene:getActorIndex(actor)
    assert(actor)
    for i,iactor in ipairs(self.actors) do
        if iactor == actor then
            return i
        end
    end

    return nil
end

return Scene
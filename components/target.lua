local Target = {}

Target.name = 'target'

function Target.create()
    return newObject(Target)
end

function Target:awake()
    self.stateIndex = 1
    self.states = {0, math.pi/2, math.pi}
end

function Target:draw()
end

function Target:update(dt)
    local tuples = getAllStarActorsAndWindows()
    for i,v in ipairs(tuples) do
        local actor = v.actor
        if v.window == self.actor.scene.window and (actor.pos - self.actor.pos):length() < 32 then
            if actor.name == 'Arrow' then
                actor:destroy()
                self.stateIndex = self.stateIndex + 1
                if self.states[self.stateIndex] == nil then
                    self.actor:destroy()
                end
            end
        end
    end
end

return Target
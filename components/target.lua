local Target = {}

Target.name = 'target'

function Target.create()
    return newObject(Target)
end

function Target:awake()
    self.stateIndex = 1
    self.states = {0, math.pi/4, math.pi/2, math.pi}
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
                if math.abs(self.actor.spriteRenderer.angle - actor.spriteRenderer.angle) < 0.6 then
                    love.audio.newSource('sounds/victory.ogg','static'):play()
                    self.stateIndex = self.stateIndex + 1
                    if self.states[self.stateIndex] == nil then
                        self.actor:destroy()
                    end
                else
                    local snd = love.audio.newSource('sounds/victory.ogg','static')
                    snd:setPitch(2)
                    snd:play()
                end
            end
        end
    end

    if self.states[self.stateIndex] then
        self.actor.spriteRenderer.angle = (self.actor.spriteRenderer.angle - self.states[self.stateIndex])/2
    end
end

return Target
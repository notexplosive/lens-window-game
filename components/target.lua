local Target = {}
local State = require('system/state')
Target.name = 'target'

function Target.create()
    return newObject(Target)
end

function Target:awake()
    self.stateIndex = 1
    if State:get('targets') ~= false then
        self.stateIndex = State:get('targets')
    end
    self.states = {0, math.pi/2, math.pi}
end

function Target:draw()

end

function Target:update(dt)
    local tuples = getAllStarActorsAndWindows()
    if self.actor.scene then
        for i,v in ipairs(tuples) do
            local actor = v.actor
            if v.window == self.actor.scene.window and (actor.pos - self.actor.pos):length() < 32 then
                if actor.name == 'Arrow' then
                    actor:destroy()
                    local angle = math.abs(self.actor.spriteRenderer.angle - actor.spriteRenderer.angle)
                    if angle > math.pi then
                        angle = math.pi*2 - angle
                    end

                    if angle < 0.6 then
                        love.audio.newSource('sounds/victory.ogg','static'):play()
                        self.stateIndex = self.stateIndex + 1
                        State:persist('targets',self.stateIndex)
                    else
                        local snd = love.audio.newSource('sounds/victory.ogg','static')
                        snd:setPitch(2)
                        snd:play()
                    end
                end
            end
        end

        if self.states[self.stateIndex] == nil then
            self.actor:destroy()
        end
    end

    if self.states[self.stateIndex] then
        self.actor.spriteRenderer.angle = (self.actor.spriteRenderer.angle - self.states[self.stateIndex])/2
    end
end

return Target
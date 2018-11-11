local Timer = {}

function Timer.new(seconds,onEnd)
    assert(onEnd,"onEnd must be defined for a timer")
    local self = newObject(Timer,true)
    self.timeLeft = seconds
    self.onEnd = onEnd
    return self
end

function Timer:update(dt)
    self.timeLeft = self.timeLeft - dt
    if self.timeLeft < 0 then
        self:onEnd()
        self:destroy()
    end
end

return Timer
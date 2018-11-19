local EmptyRenderer = {}

EmptyRenderer.name = 'emptyRenderer'

function EmptyRenderer.create()
    return newObject(EmptyRenderer)
end

function EmptyRenderer:draw(x,y)
    -- left blank so it can be overridden
end

return EmptyRenderer
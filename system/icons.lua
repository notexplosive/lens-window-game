local Icons = {}

Icons.iconNames = {'folder','text','app','textboy','locater','internet','workitems','demon','shell','image','warning'}
Icons.image = love.graphics.newImage('images/icons.png')
Icons.quads = nil
Icons.font = love.graphics.newFont('fonts/Roboto-Light.woff',math.floor(12))

function Icons.initializeQuads()
    Icons.quads = {}
    for i,name in ipairs(Icons.iconNames) do
        Icons.quads[name] = love.graphics.newQuad((i-1)*32,0,32,32,Icons.image:getDimensions())
    end
end

function Icons.getQuad(iconName)
    if Icons.quads == nil then
        Icons.initializeQuads()
    end

    assert(Icons.quads[iconName], 'Path ' .. iconName .. ' not found')
    return Icons.image,Icons.quads[iconName]
end

return Icons
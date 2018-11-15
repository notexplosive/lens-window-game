local Icons = {}

Icons.iconNames = {'folder','text','app','textboy','locator','internet','workitems','demon','shell','image','warning','settings'}
Icons.uiNames = {'back','checkbox'}
Icons.image = love.graphics.newImage('images/icons.png')
Icons.uiImage = love.graphics.newImage('images/ui.png')
Icons.quads = nil
Icons.font = love.graphics.newFont('fonts/Roboto-Light.woff',math.floor(12))
Icons.iconNamesMap = {}
Icons.uiNamesMap = {}

function Icons.initializeQuads()
    Icons.quads = {}
    for i,name in ipairs(Icons.iconNames) do
        Icons.quads[name] = love.graphics.newQuad((i-1)*32,0,32,32,Icons.image:getDimensions())
        Icons.iconNamesMap[name] = true
    end

    for i,name in ipairs(Icons.uiNames) do
        Icons.quads[name] = love.graphics.newQuad((i-1)*32,0,32,32,Icons.uiImage:getDimensions())
        Icons.uiNamesMap[name] = true
    end
end

function Icons.getQuad(iconName)
    if Icons.quads == nil then
        Icons.initializeQuads()
    end

    assert(Icons.quads[iconName], 'Path ' .. iconName .. ' not found')

    local image = Icons.image
    if Icons.iconNamesMap[iconName] == nil then
        assert(Icons.uiNamesMap[iconName], 'No icon or ui image ' .. iconName .. ' found')
        image = Icons.uiImage
    end
    return image,Icons.quads[iconName]
end

return Icons
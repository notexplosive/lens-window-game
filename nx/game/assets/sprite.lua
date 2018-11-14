local Sprite = {}

function Sprite.new(filename,gridSizeX,gridSizeY)
    local self = newObject(Sprite)
    self.filename = filename
    self.image = love.graphics.newImage(filename)
    self.quads = {}
    self.animations = {}
    self.gridWidth = gridSizeX
    self.gridHeight = gridSizeY
    for y = 0, self.image:getHeight()-gridSizeY*2,gridSizeY do
        for x = 0, self.image:getWidth()-gridSizeX*2,gridSizeX do
            self.quads[#self.quads + 1] = love.graphics.newQuad(x,y,gridSizeX,gridSizeY,self.image:getDimensions())
        end
    end
    return self
end

function Sprite:createAnimation(animName,startQuad,endQuad)
    self.animations[animName] = {
        first=startQuad,
        last=endQuad,
    }
end

return Sprite
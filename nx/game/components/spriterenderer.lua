local Sprite = require('nx/game/assets/sprite')
local SpriteRenderer = {}

SpriteRenderer.name = 'spriteRenderer'

function SpriteRenderer.create()
    return newObject(SpriteRenderer)
end

function SpriteRenderer:awake()
    self.currentAnimation = nil
    self.currentFrame = 0
    self.fps = 10
    self.scale = 1
    self.scaleX = 1
    self.scaleY = 1
    self.angle = 0
    self.flipX = false
    self.flipY = false
    self.color = {1,1,1,1}
end

function SpriteRenderer:draw(x,y)
    if self.sprite then
        local quad = self.sprite.quads[1]
        if self.currentAnimation then
            quad = self.sprite.quads[math.floor(self.currentFrame + self.currentAnimation.first)]
        end

        if quad == nil then
            quad = love.graphics.newQuad(0, 0, self.sprite.gridWidth, self.sprite.gridWidth, self.sprite.image:getDimensions())
        end

        local xFactor,yFactor = 1,1
        if self.flipX then
            xFactor = -1
        end
        if self.flipY then
            yFactor = -1
        end

        love.graphics.setColor(self.color)

        love.graphics.draw(self.sprite.image,
            quad,
            x,
            y,
            self.angle,
            self.scale*xFactor*self.scaleX,
            self.scale*yFactor*self.scaleY,
            self.sprite.gridWidth/2,
            self.sprite.gridHeight/2)
    end
end

function SpriteRenderer:update(dt)
    self.currentFrame = self.currentFrame + dt * self.fps
    if self.currentAnimation then
        self.currentFrame = self.currentFrame % self.currentAnimation.last
        if self.currentAnimation.last == self.currentAnimation.first then
            self.currentFrame = 0
        end
    end
end

-- Accessors and Mutators
function SpriteRenderer:setSprite(sprite)
    assert(sprite.type == Sprite)
    self.sprite = sprite
    return self
end

function SpriteRenderer:setAnimation(animName)
    assert(self.sprite)
    assert(self.sprite.animations[animName],'No animation called ' .. animName)

    if self.currentAnimation == self.sprite.animations[animName] then
        return
    end

    self.currentAnimation = self.sprite.animations[animName]
    self.currentFrame = 0
    return self
end

function SpriteRenderer:setFrame(index)
    self.currentFrame = self.currentAnimation.first + index - 2
end

function SpriteRenderer:getAnimation()
    if self.currentAnimation == nil then
        return 'nil'
    end
    return self.currentAnimation.name
end

function SpriteRenderer:setFlipX(b)
    self.flipX = b
end

function SpriteRenderer:setFlipY(b)
    self.flipY = b
end

return SpriteRenderer

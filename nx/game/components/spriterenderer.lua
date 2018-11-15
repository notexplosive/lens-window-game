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
    self.angle = 0
    self.flipX = false
    self.flipY = false
end

function SpriteRenderer:draw(x,y)
    if self.sprite then
        local quad = self.sprite.quads[1]
        if self.currentAnimation then
            quad = self.sprite.quads[math.floor(self.currentFrame + self.currentAnimation.first)]
        end

        local xFactor,yFactor = 1,1
        if self.flipX then
            xFactor = -1
        end
        if self.flipY then
            yFactor = -1
        end

        love.graphics.draw(self.sprite.image,
            quad,
            x,
            y,
            self.angle,
            self.scale*xFactor,
            self.scale*yFactor,
            self.sprite.gridWidth/2,
            self.sprite.gridHeight/2)
    end
end

function SpriteRenderer:update(dt)
    self.currentFrame = self.currentFrame + dt * self.fps
    if self.currentAnimation then
        self.currentFrame = self.currentFrame % self.currentAnimation.last
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

function SpriteRenderer:setFlipX(b)
    self.flipX = b
end

function SpriteRenderer:setFlipY(b)
    self.flipY = b
end

return SpriteRenderer

local Assets = require('assets')
local KeyBehavior = {}

local SimplePhysics = require('components/simplephysics')
local SimpleCollider = require('components/simplecollider')
local SpriteRenderer = require('nx/game/components/spriterenderer')

KeyBehavior.name = 'key'

function KeyBehavior.create()
    return newObject(KeyBehavior)
end

function KeyBehavior:awake()
    self.actor:addComponent(SimplePhysics)
    self.actor:addComponent(SimpleCollider)
    self.actor:addComponent(SpriteRenderer):setSprite(Assets.keys):setAnimation('all')

    self.actor.simpleCollider.onCollide = function(self,otherbody)
        if otherbody.actor.name == 'ShadowMan' then
            State:persist(self.actor.key.keyName)
            love.audio.newSource('sounds/good.ogg','static'):play()
        end
    end

    self.keyName = ''
    self.keyType = 1
    self.hitBottom = false
end

function KeyBehavior:draw()
    self.actor.spriteRenderer:setFrame(self.keyType)
end

function KeyBehavior:update(dt)
    local names = {'red','blue','black'}
    local keyName = names[self.keyType]
    self.keyName = keyName..'Key'

    if State:get(self.keyName) then
        print(self.keyName,'destroyed')
        self.actor:destroy()
    end
    
    if self.actor.scene then
        local maxY = self.actor.scene.height - self.actor.simpleCollider.radius

        local posY,top,bottom = clamp(self.actor.pos.y, 0, self.actor.scene.height - self.actor.simpleCollider.radius)
        if bottom then
            self.actor.pos.y = posY
            self.hitBottom = true
            self.actor.simplePhysics.velocity.y = 0
            love.audio.newSource('sounds/key_impact.ogg', 'static'):play()
        end
    else
        -- no scene
        self.hitBottom = false
    end

    if not self.hitBottom then
        self.actor.simplePhysics.velocity.y = self.actor.simplePhysics.velocity.y + 1
    end
end

function KeyBehavior:setKeyType(n)
    self.keyType = n
end

return KeyBehavior
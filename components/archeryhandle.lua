local Vector = require('nx/vector')
local Actor = require('nx/game/actor')
local SpriteRenderer = require('nx/game/components/spriterenderer')
local Assets = require('assets')
local ArrowBehavior = require('components/arrow')
local ArcheryHandle = {}

ArcheryHandle.name = 'archeryHandle'

function ArcheryHandle.create()
    return newObject(ArcheryHandle)
end

function ArcheryHandle:awake()
    self.actor.pos = Vector.new(200,64)
    self.originalPos = self.actor.pos:clone()
    self.grabbed = false
    self.wiggleframe = 0
    self.sound = love.audio.newSource('sounds/bow_setup.ogg','static')
end

function ArcheryHandle:draw()
    local mp = Vector.new(love.mouse.getPosition()) - self.actor.scene.window.pos - Vector.new(0,32)
    mp.x = clamp(mp.x, 0, self.actor.scene.width-100)
    mp.y = clamp(mp.y, 0, self.actor.scene.height)

    love.graphics.setColor(1,1,1,1)
    
    if (self.actor.pos - mp):length() < 10 then
        if gClickedThisFrame and not self.grabbed then
            self.grabbed = true
        end
    end

    local firingVec =  self.originalPos - self.actor.pos
    local power = firingVec:length()

    local height = 1 - power/400
    self.actor.scene:getActor('Bow').spriteRenderer.scaleY = height
    self.actor.scene:getActor('Bow').spriteRenderer.scaleX = 1 + power/500

    if power > 50 and not self.playedSound then
        self.sound:play()
        self.playedSound = true
    end

    if power < 50 then
        self.playedSound = false
    end

    if power > 100 then
        self.sound:setPitch(power / 100)
    end

    if love.mouse.isDown(1) then
        if self.grabbed then
            self.actor.pos = mp
        end
    else
        self.sound:stop()
        if self.grabbed then
            local snd = love.audio.newSource('sounds/bow_fired.ogg', 'static')
            snd:setVolume( power/100 )
            snd:play()

            local arrow = Actor.new('Arrow',true)
            arrow:addComponent(SpriteRenderer)
            arrow:addComponent(ArrowBehavior)
            arrow.spriteRenderer:setSprite(Assets.arrow)
            arrow.pos = self.originalPos:clone()
            arrow.arrowBehavior.velocity = firingVec * 5
            self.actor.scene:addActor(arrow)
        end
        self.grabbed = false
        self.playedSound = false
        self.wiggleframe = power
    end

    love.graphics.setColor(1,0,1,1)
    if self.grabbed then
        
    else
        if self.wiggleframe > 1 then
            self.actor.pos = self.originalPos + Vector.new(math.random(-self.wiggleframe/2,self.wiggleframe/2),0)
            self.wiggleframe = self.wiggleframe - 1
        else
            self.actor.pos = self.originalPos
        end
    end

    love.graphics.line(self.actor.pos.x,self.actor.pos.y,self.originalPos.x,self.originalPos.y + 28 * height)
    love.graphics.line(self.actor.pos.x,self.actor.pos.y,self.originalPos.x,self.originalPos.y - 28 * height)
end

function ArcheryHandle:update(dt)
    
end

return ArcheryHandle
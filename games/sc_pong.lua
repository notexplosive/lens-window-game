local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')
local GameTemplate = require('gametemplate')
local Assets = require('assets')
local Scene = require('nx/game/scene')
local Actor = require('nx/game/actor')

local PaddleMovementBehavior = require('components/paddlemovement')
local SimplePhysics = require('components/simplephysics')
local SimpleCollider = require('components/simplecollider')
local BoxCollider = require('components/boxcollider')
local EmptyRenderer = require('nx/game/components/emptyrenderer')

local app = GameTemplate.new('Pong',250,250)
app.icon = 'app'
app.iconName = 'Pong'
app.showInGames = false

function drawPaddle(self,x,y)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill',
        x - self.actor.paddleMovementBehavior.width/2,
        y - self.actor.paddleMovementBehavior.height/2,
        self.actor.paddleMovementBehavior.width,
        self.actor.paddleMovementBehavior.height)
end

function app:onStart(window,args)
    local leftPaddle = Actor.new('LeftPaddle',true)
    local rightPaddle = Actor.new('RightPaddle')
    
    rightPaddle.pos = Vector.new(self.width-8,125)
    rightPaddle:addComponent(PaddleMovementBehavior)
    rightPaddle:addComponent(EmptyRenderer).draw = drawPaddle

    leftPaddle.pos = Vector.new(8,125)
    leftPaddle:addComponent(PaddleMovementBehavior)
    leftPaddle:addComponent(EmptyRenderer).draw = drawPaddle

    local ball = Actor.new('Ball')
    ball.pos = Vector.new(125,125)
    ball:addComponent(EmptyRenderer).draw = function(self,x,y)
        love.graphics.setColor(1,1,1,1)
        love.graphics.circle('fill',x,y,8)
    end

    local phys = ball:addComponent(SimplePhysics)
    phys.onHitEdge = function(self)
        self.actor.pos = Vector.new(125,125)
    end
    phys.velocity = Vector.new(1,3):normalized() * 5

    ball:addComponent(SimpleCollider).customCollide = function(self,other)
        if other.actor.collider.type == BoxCollider then
            local normalizedVel = self.actor.simplePhysics.velocity:normalized()
            normalizedVel = normalizedVel * 8 -- radius
            if isWithinBox(
                self.actor.pos.x + normalizedVel.x,
                self.actor.pos.y + normalizedVel.y,
                other.actor.collider:getCollisionBox()
                ) then
                    --self:onCollide(other.actor.collider)

                    -- you wouldn't normally call another body's onCollide, would risk infinite loop
                    other.actor.collider:onCollide(self)
            end
            self.actor.simplePhysics.velocity.y = -self.actor.simplePhysics.velocity.y
        end
    end

    self.scene:addActor(
        leftPaddle,
        rightPaddle,
        ball
    )

    -- so its input can be updated
    self.leftPaddle = leftPaddle.paddleMovementBehavior
    self.rightPaddle = rightPaddle.paddleMovementBehavior
    self.ball = ball
end

function app:keyPress(key,isDesktop)
    
end

function app:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill',0,0,self.canvas:getDimensions())
end

function app:update(dt)
    local y = 0
    if love.keyboard.isDown('up') then
        y = y - 1
    end
    if love.keyboard.isDown('down') then
        y = y + 1
    end
    self.leftPaddle.inputY = y * self.leftPaddle.speed * dt

    local enemyY = 0

    if self.ball.pos.y < self.rightPaddle.actor.pos.y then
        enemyY = -1
    else
        enemyY = 1
    end
    self.rightPaddle.inputY = enemyY * self.rightPaddle.speed * dt

    local ballY,hitBottom,hitTop = clamp(self.ball.pos.y,8,self.height-8)
    self.ball.y = ballY
    if hitBottom or hitTop then
        self.ball.simplePhysics.velocity.y = -self.ball.simplePhysics.velocity.y
    end
end

return app
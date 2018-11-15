local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

local app = AppTemplate.new('Lens',128,128)
app.icon = 'shell'
app.iconName = 'Lens'
app.enabledControlButtons = {true,false,false}
app.allowResizing = false

function app:onStart(window,args)
    self.state.actors = {}
end

function app:update(dt)
    for i,act in ipairs(self.state.actors) do
        act:sceneUpdate(dt)
    end
end

function app:draw(selected,mp)
    if selected then
        love.graphics.setColor(0.5, 0.5, 1)
    else
        love.graphics.setColor(0.5, 0.5, .7)
    end
    love.graphics.rectangle('fill',0,0,self.canvas:getDimensions())

    local tuples = getAllStarActorsAndWindows()

    for i,act in ipairs(self.state.actors) do
        append(tuples,{actor=act,window=nil})
    end

    for i,tuple in ipairs(tuples) do
        local globalPosition = tuple.actor.pos:clone()
        if tuple.window then
            globalPosition = globalPosition + tuple.window.pos
        end

        local lensPosition = globalPosition - self.pos

        if tuple.actor.isLensed then
            love.graphics.setColor(1,1,1,1)
        else
            love.graphics.setColor(0.5,0.5,1,1)
        end
        tuple.actor:draw(lensPosition:components())
        
        local isLensed = isWithinBox(lensPosition.x,lensPosition.y,0,0,self.width,self.height)
        if selected then
            if tuple.actor.isLensed ~= nil and tuple.actor.isLensed ~= isLensed then
                DEBUG = true
                if isLensed then
                    if DEBUG then local snd = love.audio.newSource('sounds/no.ogg', 'static') snd:setPitch(2) snd:play() end
                    self.behavior:takeOwnership(tuple.actor,tuple.window)
                else
                    if DEBUG then local snd = love.audio.newSource('sounds/no.ogg', 'static') snd:setPitch(2.5) snd:play() end
                    local windows = Window.getAllInDrawableOrder()
                    local newOwner = nil
                    for j,v in ipairs(windows) do
                        if isWithinBox(tuple.actor.pos.x,tuple.actor.pos.y,windows[j]:getCanvasPositions()) then
                            newOwner = windows[j]
                            break
                        end
                    end

                    if newOwner then
                        self.behavior:loseOwnership(tuple.actor,newOwner)
                    end
                end
            end
            tuple.actor.isLensed = isLensed
        end
    end
end

function app.behavior:takeOwnership(actor,oldOwner)
    if not contains(self.state.actors,actor) then
        -- if outside of bounds of window:
        actor.pos = actor.pos + oldOwner.pos
        actor:removeFromScene()
        append(self.state.actors,actor)
    end
end

function app.behavior:loseOwnership(actor,newOwner)
    if newOwner.scene then
        deleteFromList(self.state.actors,actor)
        actor.pos = actor.pos - newOwner.pos
        newOwner.scene:addActor(actor)
    end
end

return app
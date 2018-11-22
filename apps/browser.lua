local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')
local State = require('system/state')

local app = AppTemplate.new('NetScrape Navigator')
app.icon = 'internet'
app.iconName = 'NetScrape'

local Browser = app

function Browser:onStart(window,args)
    self.state.spawnTimer = 1
    self.state.childCounter = 0
    self.state.time = 0
    self.state.timeScale = 1
end

function Browser:draw(selected,mp)
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill',1,1,w-2,h-2)
    love.graphics.setColor(0,0,0)
    if not (State:get('redKey') and State:get('blueKey') and State:get('blackKey')) then
        love.graphics.print('Connecting to information superhighway...')
    else
        love.graphics.print('Congratulations! You won!\n\nThank you for playing!!\n\nIt is now safe to turn off your computer.')
    end
end

function Browser:update(dt)
    if not (State:get('redKey') and State:get('blueKey') and State:get('blackKey')) then
        if self.state.spawnTimer > 0 then
            self.state.spawnTimer = self.state.spawnTimer - dt
            if self.state.spawnTimer < 0 then
                local popup = self:spawnChild('popup')
                popup.title = 'NetScrape Error'
                popup.state.label = 'Unspecified Network Error'
                if self.state.childCounter == 5 then
                    popup.state.label = "Come back with the keys"
                end
                if self.state.childCounter == 6 then
                    jumpScare()
                end
                function popup:onClose()
                    if self.parent then
                        if not State:get('hasSeenJumpScare') then
                            self.parent.state.spawnTimer = 0.5
                            self.parent.state.childCounter = self.parent.state.childCounter + 1
                        else
                            self.parent:close()
                        end
                    end
                end
            end
        end
    else
        -- Win condition
        self.state.time = self.state.time - dt
        if self.state.time < 0 then
            self.state.time = (math.random(3)) * self.state.timeScale
            self.state.timeScale = self.state.timeScale * 0.8
            if self.state.timeScale < 0.0001 then
                State:deleteSave()
                love.event.quit(0)
            end
            local popUp = LaunchApp('popup','CONGRATULATIONS\nYOU WON')
            popUp.pos = Vector.new(math.random(love.graphics.getWidth()),math.random(love.graphics.getHeight()))
        end
    end
end

function Browser:keyPress(key,isDesktop)
    
end

return Browser
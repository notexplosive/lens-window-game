local Vector = require('nx/vector')
local Window = require('system/window')
local State = require('system/state')

function love.mousepressed(x, y, button, isTouch)
    if not State.isLoggedIn then
        return 
    end

    gSelectedControlButton = nil

    love.audio.newSource('sounds/mousedown.ogg', 'static'):play()

    if button == 1 then
        gClickedThisFrame = true
        gSelectedWindow = nil
        local windows = Window.getAllDraw()
        for i,window in ipairs(windows) do
            if window:getHover() and window.visible then
                gSelectedWindow = window
                gSelectedWindow:bringToFront()
                if window:getHeaderHover() and not window:getHoverControlButtons()  then
                    gDragging = true
                end

                local controlButton = window:getHoverControlButtons()
                if controlButton then
                    gSelectedControlButton = controlButton
                end
                break
            end
        end

        -- A window was not clicked this click, so deselect current window
        if not gSelectedWindow then
            if nx_AllDrawableObjects[1] ~= nx_null then
                Window.bringToFront(nx_null)
            end
        end
    end
end


function love.mousereleased(x, y, button, isTouch)
    if not State.isLoggedIn then
        return 
    end
    
    local snd = love.audio.newSource('sounds/mousedown.ogg', 'static')
    snd:setPitch(0.9)
    snd:play()

    if button == 1 then
        gDragging = false
        gSelectedWindow = nil

        local windows = Window.getAllDraw()
        for i,window in ipairs(windows) do
            if window:getHover() and window.visible then
                local controlButton = window:getHoverControlButtons()
                if controlButton == gSelectedControlButton then
                    if controlButton == 1 then
                        window:close()
                    end

                    if controlButton == 2 then
                        window:setFullscreen(not window.fullscreen)
                    end

                    if controlButton == 3 then
                        window:minimize()
                    end
                end
                break
            end
        end
        
        gSelectedControlButton = nil
    end
end

function love.mousemoved(x, y, dx, dy)
    local pos = Vector.new(x,y)
    local vel = Vector.new(dx,dy)
    if love.mouse.isDown(1) then
        if gSelectedWindow ~= nil and gDragging then
            gSelectedWindow.pos = gSelectedWindow.pos + vel

            if gSelectedWindow.fullscreen and dy > 1 then
                gSelectedWindow:setFullscreen(false)
                gSelectedWindow.pos.x = x - gSelectedWindow.width/2
                gSelectedWindow.pos.y = 0
            end
        end
    end
end

function love.mousefocus(f)
    if not f then
        love.mousereleased(0,0,1,false)
    end
end

function love.wheelmoved(x, y)
    local selectedWindow = nx_AllDrawableObjects[1]
    if selectedWindow.type == Window then
        selectedWindow:scroll(y)
    end
end

function isWithinBox(mx,my,x,y,width,height)
    return mx > x and mx < x + width and my > y and my < y + height
end
local Vector = require('nx/vector')
local Icons = require('system/icons')
local Window = {}

Window.headerHeight = 32
Window.borderWidth = 1
Window.OSColor =  {52/255, 123/255, 237/255}--{0.1,0.3,1}
Window.OSFont = love.graphics.newFont('fonts/Roboto.woff',math.floor(Window.headerHeight * 2/3))
Window.menuBarHeight = 38
Window.controlButtonImage = love.graphics.newImage('images/controlbuttons.png')
Window.controlButtonSize = 32
Window.controlButtonQuads = {
    love.graphics.newQuad(32*0,0,32,32,Window.controlButtonImage:getDimensions()),
    love.graphics.newQuad(32*1,0,32,32,Window.controlButtonImage:getDimensions()),
    love.graphics.newQuad(32*2,0,32,32,Window.controlButtonImage:getDimensions())
}
gHover = nil
gDragging = false

function Window.new(title,width,height)
    local self = newObject(Window,true)

    self.pos = Vector.new()
    self.width = width
    self.height = height
    self.title = title
    self.enabledControlButtons = {true,true,true}
    self.fullscreen = false
    self.canvas = love.graphics.newCanvas(width,height)
    self.icon = nil
    self.visible = true
    self.selectedCorner = nil
    self.children = {}

    -- Draw function for the windows canvas
    -- not implemented on purpose, as they are to be overwritten
    function self.canvasDraw() end
    function self.textInput() end
    function self.keyPress() end
    function self.scroll() end

    -- Any userdata needed for the draw function
    self.state = {} -- empty on purpose

    self:bringToFront()
    
    return self
end

function Window:update(dt)
    if gSelectedWindow ~= self then
        if self.pos.y < 0 then
            self.pos.y = 0
        end

        if self.pos.x < -100 then
            self.pos.x = 0
        end

        if self.pos.x + self.width > love.graphics.getWidth() + 100 then
            self.pos.x = love.graphics.getWidth() - self.width
        end

        if self.pos.y > love.graphics.getHeight() - 100 then
            self.pos.y = love.graphics.getHeight() - 100
        end
    end

    if self.canvasUpdate then
        self.canvasUpdate(dt)
    end
end

function Window:draw(x,y)
    if not self.visible then
        return
    end

    local dimFactor = 1
    local selected = self:inFocus()

    -- Background
    if not selected then
        dimFactor = 1.3
    end
    local hx,hy,hwidth,hheight = self:getHeaderPositions()
    local _,_,wwidth,wheight = self:getBackgroundPositions()

    local dimLower = 0.7 * dimFactor
    local brightenUpper = 1.2 * dimFactor

    if selected then
        love.graphics.setColor(0,0,0,0.4)
    else
        love.graphics.setColor(0,0,0,0.1)
    end

    love.graphics.rectangle('fill', hx-2, hy-2, hwidth+4, wheight+4)

    love.graphics.setColor(Window.OSColor[1] * dimFactor, Window.OSColor[2] * dimFactor,Window.OSColor[3] * dimFactor)
    love.graphics.rectangle('fill', hx, hy, hwidth, wheight)
    love.graphics.setColor(Window.OSColor[1] * dimLower, Window.OSColor[2] * dimLower,Window.OSColor[3] * dimLower)
    love.graphics.rectangle('fill', hx, hy + 3*hheight/4, hwidth, wheight/2)
    love.graphics.setColor(Window.OSColor[1] * brightenUpper, Window.OSColor[2] * brightenUpper,Window.OSColor[3] * brightenUpper)
    love.graphics.rectangle('fill', hx, hy, hwidth, hheight/4)

    -- Title
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(Window.OSFont)
    love.graphics.print(self.title, math.floor(hx + Window.headerHeight),math.floor(hy + Window.headerHeight * 1/8))

    -- Icon
    love.graphics.setColor(1,1,1,1)
    if self.icon then
        local image,quad = Icons.getQuad(self.icon)
        love.graphics.draw(image,quad,hx+4,hy+4,0,0.8,0.8)
    else
        love.graphics.circle('fill',hx + Window.headerHeight / 2,hy + Window.headerHeight / 2, Window.headerHeight / 3)
    end

    -- Control buttons
    love.graphics.setColor(1,1,1)

    if not selected then
        love.graphics.setColor(dimLower*1.3,dimLower*1.3,dimLower*1.3)
    end
    
    for i=1,3 do
        if self:isControlButtonEnabled(i) then
            local cbx,cby = self:getControlButtonPosition(i)
            local quad = Window.controlButtonQuads[i]
            local image = Window.controlButtonImage
            
            love.graphics.setColor(.9,.9,1)
            local mx,my = love.mouse.getPosition()
            local isHover = isWithinBox(mx,my,self:getControlButtonPosition(i))
            if isHover then
                love.graphics.setColor(1,1,1)
            end

            if gSelectedControlButton == i and selected and isHover then
                love.graphics.setColor(0.7,0.7,0.7)
            end

            love.graphics.draw(image,quad,cbx,cby,0,0.9,0.9)
        end
    end

    self.hoverCorner = nil
    self:handleResizing()

    -- Canvas
    local canvasX = hx + Window.borderWidth
    local canvasY = hy + Window.headerHeight
    local canvasWidth = hwidth - Window.borderWidth * 2
    local canvasHeight = wheight - Window.headerHeight - Window.borderWidth

    -- Check if canvas resize needs to happen
    local canvas = love.graphics.getCanvas()
    local cw,ch = self.canvas:getDimensions()
    if cw ~= canvasWidth or ch ~= canvasHeight then
        self.canvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
    end

    love.graphics.setCanvas(self.canvas)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(0.6,0.6,0.6,1)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())
    local mousePosX,mousePosY = love.mouse.getPosition()
    mousePosX = mousePosX - self.pos.x
    mousePosY = mousePosY - self.pos.y - Window.headerHeight
    love.graphics.setColor(1, 1, 1, 1)
    self:canvasDraw(nx_AllDrawableObjects[1] == self,Vector.new(mousePosX,mousePosY))
    love.graphics.setCanvas(canvas)

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.canvas,canvasX,canvasY)
end

function Window:getBackgroundPositions()
    local x,y,width,height = self.pos.x,self.pos.y,self.width + Window.borderWidth * 2,self.height + Window.headerHeight + Window.borderWidth

    if self.fullscreen then
        x = 0
        y = 0
        height = love.graphics.getHeight() - Window.menuBarHeight
        width = love.graphics.getWidth()
    end

    return x,y,width,height
end

function Window:getHeaderPositions()
    local x,y,width = self:getBackgroundPositions()

    return x,
        y,
        width,
        Window.headerHeight
end

function Window:getHeaderHover()
    local mx,my = love.mouse.getPosition()
    local x,y,width,height = self:getHeaderPositions()

    if mx > x and
        my > y and
        mx < x + width and
        my < y + height then
        return true
    end

    return false
end

function Window:getControlButtonPosition(i,bgx,bgy,bgRight)
    local x,y,width,height = self:getHeaderPositions()
    return 
        x + width - (Window.controlButtonSize) * i + 1,
        y + 2,
        Window.controlButtonSize,
        Window.controlButtonSize
end

function Window:getHoverControlButtons()
    local mx,my = love.mouse.getPosition()
    for i=1,3 do
        local x,y,width,height = self:getControlButtonPosition(i)
        if mx > x and
            my > y and
            mx < x + width and
            my < y + height and
            self:isControlButtonEnabled(i) then
            return i
        end
    end

    return nil
end

function Window:isControlButtonEnabled(i)
    return self.enabledControlButtons[i]
end

function Window:getHover()
    local x,y,width,height = self:getBackgroundPositions()
    local mx,my = love.mouse.getPosition()
    if mx > x and
        my > y and
        mx < x + width and
        my < y + height then
        return true
    end
end

function Window:bringToFront()
    local index = getDrawIndex(self)
    if index and index ~= 1 then
        local temp = nx_AllDrawableObjects[index]
        nx_AllDrawableObjects[index] = nil

        for i=index-1,1,-1 do
            nx_AllDrawableObjects[i+1] = nx_AllDrawableObjects[i]
        end
        nx_AllDrawableObjects[1] = temp
    end
end

function Window:setFullscreen(b)
    self.fullscreen = b
end

function Window:getCanvasPositions()
    local hx,hy,hwidth,hheight = self:getHeaderPositions()
    local _,_,wwidth,wheight = self:getBackgroundPositions()
    return hx + Window.borderWidth,
        hy + Window.headerHeight,
        hwidth - Window.borderWidth * 2,
        wheight - Window.headerHeight - Window.borderWidth
end

function Window:handleResizing()
    -- This is spaghetti mess
    if not love.mouse.isDown(1) then
        self.selectedCorner = nil
    end

    local topWindow = nil
    for i,v in ipairs(nx_AllDrawableObjects) do
        if v.type == Window then
            topWindow = v
            break
        end
    end

    -- Top window is different from being in focus!
    if topWindow == self then
        local left,top,width,height = self:getBackgroundPositions()
        local right,bottom = left+width,top+height
        local pointNames = {'leftop','righttop','leftbottom','rightbottom'}
        local points = {
            Vector.new(left,top),
            Vector.new(right,top),
            Vector.new(left,bottom),
            Vector.new(right,bottom)
        }
        local pointMap = {
            lefttop=points[1],
            righttop=points[2],
            leftbottom=points[3],
            rightbottom=points[4]
        }

        local mousePos = Vector.new(love.mouse.getPosition())

        local isCorner = false
        if not isWithinBox(mousePos.x,mousePos.y,left,top,width,height) then
            local radiusFromCorner = 16
            --[[
            if self.selectedCorner == nil and gSelectedControlButton == nil and gSelectedWindow == nil then
                for i,pointName in ipairs(pointNames) do
                    local diff = mousePos - points[i]
                    local distance = diff:length()
                    if distance < radiusFromCorner then
                        self.hoverCorner = pointName
                        isCorner = true
                        if gClickedThisFrame then
                            self.selectedCorner = pointName
                            break
                        end
                    end
                end
            end
            ]]

            -- No corners were selected, let's try edges
            if not self.selectedCorner and isWithinBox(mousePos.x,mousePos.y,
                                                        left-radiusFromCorner,
                                                        top-radiusFromCorner,
                                                        width+radiusFromCorner*2,
                                                        height+radiusFromCorner*2) then
                self.hoverCorner = ''
                if math.abs(left - mousePos.x) < radiusFromCorner then
                    self.hoverCorner = self.hoverCorner .. 'left'
                end

                if math.abs(right - mousePos.x) < radiusFromCorner then
                    self.hoverCorner = self.hoverCorner .. 'right'
                end

                if math.abs(bottom - mousePos.y) < radiusFromCorner then
                    self.hoverCorner = self.hoverCorner .. 'bottom'
                end

                if math.abs(top - mousePos.y) < radiusFromCorner then
                    self.hoverCorner = self.hoverCorner .. 'top'
                end
                
                if self.hoverCorner ~= '' then
                    if gClickedThisFrame then
                        self.selectedCorner = self.hoverCorner
                    end
                else
                    self.hoverCorner = nil
                end
            end
        end
        
        -- Corners
        if self.selectedCorner and pointMap[self.selectedCorner] then
            local diff = mousePos - pointMap[self.selectedCorner]
            self:bringToFront()
            if self.selectedCorner == 'rightbottom' then
                self.width = self.width + diff.x
                self.height = self.height + diff.y
            end

            if self.selectedCorner == 'leftbottom' then
                self.pos.x = self.pos.x + diff.x
                self.width = self.width - diff.x
                self.height = self.height + diff.y
            end

            if self.selectedCorner == 'righttop' then
                self.width = self.width + diff.x
                self.height = self.height - diff.y
                self.pos.y = self.pos.y + diff.y
            end

            if self.selectedCorner == 'lefttop' then
                self.width = self.width - diff.x
                self.pos.x = self.pos.x + diff.x
                self.height = self.height - diff.y
                self.pos.y = self.pos.y + diff.y
            end
        end

        -- Edges
        if self.selectedCorner and not pointMap[self.selectedCorner] then
            local diff = mousePos - pointMap['lefttop']
            if self.selectedCorner == 'left' then
                self.width = self.width - diff.x
                self.pos.x = self.pos.x + diff.x
            end

            if self.selectedCorner == 'top' then
                self.pos.y = self.pos.y + diff.y
                self.height = self.height - diff.y
            end

            diff = mousePos - pointMap['rightbottom']
            if self.selectedCorner == 'right' then
                self.width = self.width + diff.x
            end

            if self.selectedCorner == 'bottom' then
                self.height = self.height + diff.y
            end

        end

        if self.width < self:minimumWidth() then
            local d = self.width - self:minimumWidth()

            self.width = self:minimumWidth()
            if self.selectedCorner:match('left') then
                self.pos.x = self.pos.x + d
            end
        end

        if self.height < self:minimumHeight() then
            local d = self.height - self:minimumHeight()
            self.height = self:minimumHeight()
            if self.selectedCorner:match('top') then
                self.pos.y = self.pos.y + d
            end
        end
    end
end

function Window:minimumWidth()
    return 32 + Window.controlButtonSize * 3 + Window.OSFont:getWidth(self.title)
end

function Window:minimumHeight()
    return 128
end

function Window:bringNextWindowToFront()
    local nextWindowAvailable = false
    local index = getDrawIndex(self)
    for i=index+1,#nx_AllDrawableObjects do
        local object = nx_AllDrawableObjects[i]
        if object.type == Window and object.visible then
            object:bringToFront()
            nextWindowAvailable = true
            break
        end
    end

    if not nextWindowAvailable then
        Window.bringToFront(nx_null)
    end
end

function Window:close()
    for i,v in ipairs(self.children) do
        v:destroy()
    end

    self:bringNextWindowToFront()
    self:destroy()
end

function Window:minimize()
    self:bringNextWindowToFront()
    self.visible = false
end

function Window:maximize()
    self.visible = true
end

function Window:inFocus()
    return nx_AllDrawableObjects[1] == self
end

function Window.getFocusWindow()
    if nx_AllDrawableObjects[1].type == Window then
        return nx_AllDrawableObjects[1]
    end

    return nil
end

function Window.getTopWindow()
    for i,v in ipairs(nx_AllDrawableObjects) do
        if nx_AllDrawableObjects[i].type == Window then
            return nx_AllDrawableObjects[i]
        end
    end

    return nil
end

return Window
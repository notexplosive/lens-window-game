local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Apps = require('apps')
local Filesystem = require('system/filesystem')

-- EXPLORER
Apps.explorer = AppTemplate.new('File Locater','locater',450,450);

function Apps.explorer:onStart(window,args)
    if args == nil then
        args = ''
    else
        window.pos = nx_AllDrawableObjects[2].pos + Vector.new(20,20)
        window.title = window.title .. ' - ' .. args
    end

    window.state.dir = args
    window.state.content = Filesystem.inGameLS(args)

    window.state.selectedIndex = nil
end

function Apps.explorer:draw(selected,mp)
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill', 1, 1, w-2, h-2)

    drawIcons(self.state,selected,mp,false,self)
end

function Apps.explorer:keyPress(key,isDesktop)
    if key == 'return' then
        local app = self.state.content[self.state.selectedIndex]
        if app then
            executeFile(self.state.dir..'/'.. app.name,app)
        end
    end
end

function drawIcons(state,selected,mp,desktop,self)
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(Icons.font)
    
    local distanceApart = 64
    local border = 10
    local iconSize = 32 * 1.5
    local anIconWasClicked = false
    local col,row = 0,0
    for i,v in ipairs(state.content) do
        local image,quad = Icons.getQuad(v.icon)
        love.graphics.setColor(1,1,1,1)
        local x,y = border + 5 + (i-1)*distanceApart,border

        local x = border + 5 + col*distanceApart
        local y = border + row * (iconSize+distanceApart)
        
        if desktop then
            x = border + 5 + row*(distanceApart + 10)
            y = border + col * (iconSize+distanceApart/2)
        end

        col = col + 1

        if self then
            if x + iconSize + distanceApart + 5 + border > self.canvas:getWidth() then
                col = 0
                row = row + 1
            end
        else
            -- This is for the desktop, aka: row and col have swapped behavior
            if y + iconSize*3 > love.graphics:getHeight() - Window.menuBarHeight then
                col = 0
                row = row + 1
            end
        end

        local boundingBoxPos = Vector.new(x - 5, y)
        local boundingBoxDim = Vector.new(iconSize + 10, iconSize + 16)

        local iconName = v.name
        local nameWithoutExt,ext = unpack(iconName:split('.'))

        if ext == 'exe' then
            iconName = nameWithoutExt
        end

        local textWidth = love.graphics.getFont():getWidth(iconName)
        local adjustedTextWidth = textWidth + 5
        if adjustedTextWidth > distanceApart then
            adjustedTextWidth = distanceApart
        end

        if adjustedTextWidth > boundingBoxDim.x then
            local offset = adjustedTextWidth - boundingBoxDim.x
            boundingBoxPos.x = boundingBoxPos.x - offset/2
            boundingBoxDim.x = adjustedTextWidth
        end

        love.graphics.setColor(0,0,1,0.5)

        local mouseHover = isWithinBox(mp.x,mp.y,boundingBoxPos.x,boundingBoxPos.y,boundingBoxDim.x,boundingBoxDim.y)
        if mouseHover or state.selectedIndex == i then
            if selected then
                love.graphics.rectangle('line', boundingBoxPos.x, boundingBoxPos.y, boundingBoxDim.x, boundingBoxDim.y)
                if gClickedThisFrame then
                    anIconWasClicked = mouseHover
                    local oldSelectedIndex = state.selectedIndex
                    state.selectedIndex = i
                    if gDoubleClickedThisFrame and anIconWasClicked and oldSelectedIndex == i then
                        executeFile(state.dir..'/'..v.name,v)
                    end
                end
            end
        end

        if state.selectedIndex == i then
            love.graphics.setColor(0.5,0.5,.6,0.5)
            love.graphics.rectangle('fill', boundingBoxPos.x, boundingBoxPos.y, boundingBoxDim.x, boundingBoxDim.y)
        end

        love.graphics.setColor(1,1,1)
        love.graphics.draw(image,quad,x,y,0,1.5,1.5)
        
        

        love.graphics.setColor(0,0,0,1)
        if desktop then
            love.graphics.setColor(0,0,0)
            love.graphics.print(iconName,math.floor(x + iconSize/2 - textWidth/2) + 1,math.floor(y + 32 + 16) + 1)
            love.graphics.setColor(1,1,1)
        end

        
        love.graphics.print(iconName,math.floor(x + iconSize/2 - textWidth/2),math.floor(y + 32 + 16))
    end

    if gClickedThisFrame and not anIconWasClicked then
        state.selectedIndex = nil
    end

    love.graphics.setFont(oldFont)
end

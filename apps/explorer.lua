local Vector = require('nx/vector')
local Window = require('system/window')
local Icons = require('system/icons')
local AppTemplate = require('apptemplate')
local Filesystem = require('system/filesystem')

local app = AppTemplate.new('File Locator',450,450)
app.icon = 'locator'
app.iconName = 'Locator'
app.showOnDesktop = true

local Explorer = app
Explorer.pathFieldHeight = 32

function Explorer:onStart(window,args)
    if args == nil then
        args = ''
    end

    window.state.dir = args
    window.state.content = Filesystem.inGameLS(args)

    if window.state.dir == 'Games' then
        for i,game in ipairs(getAllGames()) do
            if game.showInGames then
                append(window.state.content,{name = game.iconName .. '.exe', app = game.slug, icon = game.icon})
            end
        end

        for i,game in ipairs(getAllApps()) do
            if game.showInGames then
                append(window.state.content,{name = game.iconName .. '.exe', app = game.slug, icon = game.icon})
            end
        end
    end

    if window.state.dir == 'Desktop' then
        for i,app in ipairs(getAllApps()) do
            if app.showOnDesktop then
                append(window.state.content,{name = app.iconName .. '.exe', app = app.slug, icon = app.icon})
            end
        end
    end

    window.state.selectedIndex = nil
end

function Explorer:draw(selected,mp)
    love.graphics.setColor(1,1,1,1)
    local w,h = self.canvas:getDimensions()
    love.graphics.rectangle('fill', 1, 1, w-2, h-2)

    -- back button
    love.graphics.setColor(0.6, 1, 0.6)
    local bx,by,bw,bh = 4, 4, 32, Explorer.pathFieldHeight
    local img,quad = Icons.getQuad('back')
    love.graphics.setColor(1,1,1)
    love.graphics.draw(img,quad,bx,by)

    if isWithinBox(mp.x,mp.y,bx,by,bw,bh) and gClickedThisFrame then
        local segments = self.state.dir:split('/')
        local path = ''

        for i=1,#segments-1 do
            if segments[i] ~= '' then
                path = path .. segments[i]
                if i ~= #segments-1 then
                    path = path .. '/'
                end
            end
        end

        self:onStart(self,path)
    end

    -- breadcrumb bar
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle('fill', 32 + 4, 4, w-8 - 32, Explorer.pathFieldHeight)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('PC:/'..self.state.dir,32 + 8, 8)

    drawIcons(self.state,selected,mp,false,self)
end

function Explorer:keyPress(key,isDesktop)
    if key == 'return' then
        local app = self.state.content[self.state.selectedIndex]
        if app then
            executeFile(self.state.dir..'/'.. app.name,app)
        end
    end
end

function drawIcons(state,selected,mp,desktop,self)
    love.graphics.setColor(1,1,1,1)
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(Icons.font)
    
    local distanceApart = 64 + 16
    local border = 10
    local iconSize = 32 * 1.5
    local anIconWasClicked = false
    local col,row = 0,0
    for i,v in ipairs(state.content) do
        local image,quad = Icons.getQuad(v.icon)
        love.graphics.setColor(1,1,1,1)

        local x = border + 5 + col*distanceApart
        local y = border + row * (iconSize+(distanceApart/2)) + Explorer.pathFieldHeight
        
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
                        local filename = state.dir..'/'..v.name
                        if state.dir == '' then
                            filename = v.name
                        end

                        local info = love.filesystem.getInfo('files/'..filename)
                        
                        if info and info.type == 'directory' then
                            if desktop then
                                executeFile(filename,{dir=filename})
                            else
                                self:onStart(self,filename)
                            end
                        else
                            executeFile(filename,v)
                        end
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

return Explorer
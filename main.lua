require('nx/thirdparty')
require('nx/util')
require('nx/update')
require('system/mouse')

local Vector = require('nx/vector')
local Window = require('system/window')
local MenuBar = require('system/menubar')
--local Explorer = require('explorer')
local Filesystem = require('system/filesystem')
local Apps = require('apps')

local MousePointer = require('system/mousepointer')
mousePointer = MousePointer.new()

local moonshine = require('moonshine')

gScrollIncrement = Window.OSFont:getHeight() * 5

local heroFont = love.graphics.newFont('fonts/Roboto.woff',64)
local sideKickFont = love.graphics.newFont('fonts/Roboto.woff',32)

love.audio.setVolume(0.5)

function executeFile(filename,data)
    local splitOnDot = filename:split('.')
    local format = splitOnDot[#splitOnDot]

    if format == 'txt' then
        LaunchApp('textboy',filename)
    end

    if format == 'exe' then
        LaunchApp(data.app)
    end

    if format == 'll' then
        LaunchApp('shell',filename)
    end

    if data.dir then
        LaunchApp('explorer',data.dir)
    end
end

function LaunchApp(appName,args)
    print(appName,args)
    return Apps[appName]:spawn(args)
end

love.mouse.setVisible(false)
love.graphics.setDefaultFilter('nearest', 'nearest')

local testw = Window.new("test",320,280)
testw:close()

function love.load(arg)
    State:load()
end

desktopState.dir = 'Desktop'

love.keyboard.setKeyRepeat(true)
function love.keypressed(key, scancode, isrepeat)
    if key == 'j' then
        for i,v in ipairs(Window.getAll()) do
            v.jumpScare = true
            v.fullscreen = false
            v:killUntil(math.random(30,80) / 60)
        end

        local snd = love.audio.newSource('sounds/no2.ogg','static')
        snd:setPitch(0.4)
        snd:play()
    end

    local selectedWindow = nx_AllDrawableObjects[1]
    if selectedWindow.type == Window then
        selectedWindow:keyPress(key)
    else
        Apps.explorer.keyPress({state=desktopState},key,true)
    end

    if key == 'f4' then
        os.exit()
    end
end

function love.textinput(text)
    local selectedWindow = nx_AllDrawableObjects[1]
    if selectedWindow.type == Window then
        selectedWindow:textInput(text)
    end
end

local menuBar = MenuBar.new()

-- Initialize desktop
local content = Filesystem.inGameLS('Desktop')
for i,v in ipairs(content) do
    append(desktopState.content,v)
end

function firstDraw()
    love.graphics.setColor(0.2, 0.6, 0.6)
    love.graphics.rectangle('fill',0,0,love.graphics.getDimensions())

    local mp = Vector.new(love.mouse.getPosition())
    drawIcons(desktopState, nx_AllDrawableObjects[1].type ~= Window ,mp,true)
end

local OSLogo = love.graphics.newImage('images/wonders.png')

function lastDraw()
    --love.graphics.draw(cursorImage,mx-16,my-16)
    menuBar:draw(0,love.graphics.getHeight() - Window.menuBarHeight)

    if State.isLoggedIn then
        mousePointer:setFlip(false)
        mousePointer:setAngle(0)
        mousePointer:setQuad('pointer')

        -- Corner dragging code for mouse pointer
        -- TODO: move this to the mouse pointer behavior
        local topWindow = Window.getTopWindow()
        local edge = nil
        if topWindow then
            if not love.mouse.isDown(1) then
                edge = topWindow.hoverCorner
            end
            if not edge then
                edge = topWindow.selectedCorner
            end
        end
        if topWindow and edge then
            mousePointer:setQuad('sideways')
            if edge == 'top' or edge == 'bottom' then
                mousePointer:setAngle(math.pi/2)
            end
            
            if edge ~= 'left' and edge ~= 'right' and edge ~= 'bottom' and edge ~= 'top' then
                mousePointer:setQuad('diagonal')
            end

            if edge == 'leftbottom' or edge == 'righttop' then
                -- Flip corner graphic
                mousePointer:setFlip(true)
            end
        end
        mousePointer:draw()
    else
        love.graphics.setColor(0.5,0.5,0.8)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(OSLogo,love.graphics.getWidth()/2 - 256,love.graphics.getHeight()/2 - 128 - 32,0,2,2)
        love.graphics.setColor(0.8,0.8,1)
        love.graphics.line(love.graphics.getWidth()/2,32,love.graphics.getWidth()/2,love.graphics.getHeight()-64)

        love.graphics.setColor(1,1,1)
        love.graphics.setFont(heroFont)
        love.graphics.print("Wonders nX",love.graphics.getWidth()/2+10,love.graphics.getHeight()/2 - 64)
        love.graphics.setFont(sideKickFont)
        love.graphics.print("Macrolabs Corporation",love.graphics.getWidth()/2+10,love.graphics.getHeight()/2)
    end

    gClickedThisFrame = false
    gDoubleClickedThisFrame = false
end

local doubleClickTimer = 0
local loginTimer = 0
function lastUpdate(dt)
    menuBar:update(dt)
    doubleClickTimer = doubleClickTimer - dt

    if not State.isLoggedIn then
        loginTimer = loginTimer + dt
        
        if loginTimer > 1.5 and not State.loginSoundPlayed then
            love.audio.newSource('sounds/login.ogg', 'static'):play()
            State.loginSoundPlayed = true
        end

        if loginTimer > 3 then
            State.isLoggedIn = true
        end
    end

    if gClickedThisFrame then
        if doubleClickTimer > 0 then
            gDoubleClickedThisFrame = true
            doubleClickTimer = 0
        else
            doubleClickTimer = 0.3
        end
    end
end
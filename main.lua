require('nx/thirdparty')
require('nx/util')
require('nx/update')
require('system/mouse')

local Vector = require('nx/vector')
local Window = require('system/window')
local MenuBar = require('system/menubar')
local Explorer = require('explorer')
local Apps = require('apps')
local Filesystem = require('system/filesystem')

local MousePointer = require('system/mousepointer')
local mousePointer = MousePointer.new()

local moonshine = require('moonshine')

gScrollIncrement = Window.OSFont:getHeight() * 5

local heroFont = love.graphics.newFont('fonts/Roboto.woff',64)
local sideKickFont = love.graphics.newFont('fonts/Roboto.woff',32)

love.audio.setVolume(0.5)

function executeFile(filename,data)
    local splitOnDot = filename:split('.')
    local format = splitOnDot[#splitOnDot]

    if format == 'txt' then
        LaunchApp('notepad',filename)
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
    return Apps[appName]:spawn(args)
end

love.mouse.setVisible(false)
love.graphics.setDefaultFilter('nearest', 'nearest')

local testw = Window.new("test",320,280)
testw:close()


local desktopState = {
    dir = 'Desktop',
    content = {
        {icon = 'locater', name = 'Locater.exe', app = 'explorer'},
        {icon = 'textboy', name = 'TextBoy.exe', app = 'notepad'},
        {icon = 'internet', name = 'Netscrape.exe', app = 'internet'},
        {icon = 'shell', name = 'shll.exe', app = 'shell'},
        {icon = 'app', name = 'sun.exe', app = 'sun'},
        {icon = 'app', name = 'lens.exe', app = 'lens'}
    }
}

love.keyboard.setKeyRepeat(true)
function love.keypressed(key, scancode, isrepeat)
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

function createFileObject(filename)
    local ext = filename:split('.')[2]
    local ic = 'app'
    if ext == 'txt' then
        ic = 'text'
    end

    return {icon=ic,name=filename}
end

function createFolderObject(filename,path)
    return {icon='folder',name=filename, dir=path..filename..'/'}
end

-- Initialize desktop
local content = Filesystem.inGameLS('Desktop')
for i,v in ipairs(content) do
    append(desktopState.content,v)
end

function firstDraw()
    love.graphics.setColor(0.2, 0.6, 0.6)
    love.graphics.rectangle('fill',0,0,love.graphics.getDimensions())

    local mp = Vector.new(love.mouse.getPosition())
    drawIcons(desktopState,true,mp,true)
end

function lastDraw()
    --love.graphics.draw(cursorImage,mx-16,my-16)
    menuBar:draw(0,love.graphics.getHeight() - Window.menuBarHeight)

    if State.isLoggedIn then
        mousePointer:draw()
    else
        love.graphics.setColor(0.5,0.5,1)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())

        love.graphics.setColor(1,1,1)
        love.graphics.setFont(heroFont)
        love.graphics.print("Macrolabs WandOS")
        love.graphics.setFont(sideKickFont)
        love.graphics.print("Logging you in...",0,64)
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
        
        if loginTimer > 2 then
            State.isLoggedIn = true
            love.audio.newSource('sounds/login.ogg', 'static'):play()
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
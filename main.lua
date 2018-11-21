require('global')
require('system/mouse')
require('system/keyboard')

local Vector = require('nx/vector')
local Window = require('system/window')
local MenuBar = require('system/menubar')
local Filesystem = require('system/filesystem')
local State = require('system/state')
local Timer = require('system/timer')
local UI = require('system/ui')
local MousePointer = require('system/mousepointer')
local LoginScreen = require('system/loginscreen')
local Desktop = require('system/desktop')

mousePointer = MousePointer.new()
local menuBar = MenuBar.new()
local desktop = Desktop.new()
local loginScreen = LoginScreen.new()

local testw = Window.new("test",320,280)
testw:close()

function love.load(arg)
    State:load()
end

function firstDraw()
    if State.isLoggedIn then
        desktop:draw()
    else
        loginScreen:draw()
    end
end

function lastDraw()
    if State.isLoggedIn then
        menuBar:draw(0,love.graphics.getHeight() - Window.menuBarHeight)
    end

    for i,window in ipairs(Window.getAll()) do
        if window.slug == 'lens' then
            window:draw()
        end
    end

    mousePointer:setFlip(false)
    mousePointer:setAngle(0)
    mousePointer:setQuad('pointer')
    mousePointer:draw()

    gClickedThisFrame = false
    gDoubleClickedThisFrame = false
end

local doubleClickTimer = 0

function lastUpdate(dt)
    menuBar:update(dt)
    doubleClickTimer = doubleClickTimer - dt
    desktop:update(dt)

    if gClickedThisFrame then
        if doubleClickTimer > 0 then
            gDoubleClickedThisFrame = true
            doubleClickTimer = 0
        else
            doubleClickTimer = 0.3
        end
    end

    if State:get('windowed') == love.window.getFullscreen() then
        love.window.setFullscreen(not State:get('windowed'))
    end
end

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

local heroFont = love.graphics.newFont('fonts/Roboto.woff',64)
local sideKickFont = love.graphics.newFont('fonts/Roboto.woff',32)
local OSLogo = love.graphics.newImage('images/wonders.png')

local testw = Window.new("test",320,280)
testw:close()

function love.load(arg)
    State:load()
    if not State:get('isLoggedIn') then
        Timer.new(1.5,playLoginSound)
        Timer.new(3,logIn)
    end
end

function firstDraw()
    desktop:draw()
end

function lastDraw()
    if State.isLoggedIn then
        menuBar:draw(0,love.graphics.getHeight() - Window.menuBarHeight)
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

        UI.button.new('Hello',200,200)
    end

    mousePointer:setFlip(false)
    mousePointer:setAngle(0)
    mousePointer:setQuad('pointer')
    mousePointer:draw()

    gClickedThisFrame = false
    gDoubleClickedThisFrame = false
end

local doubleClickTimer = 0
local loginTimer = 0

function lastUpdate(dt)
    menuBar:update(dt)
    doubleClickTimer = doubleClickTimer - dt

    if gClickedThisFrame then
        if doubleClickTimer > 0 then
            gDoubleClickedThisFrame = true
            doubleClickTimer = 0
        else
            doubleClickTimer = 0.3
        end
    end
end
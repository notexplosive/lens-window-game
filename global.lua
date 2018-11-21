require('nx/util')
require('nx/thirdparty')
require('nx/update')
local Apps = require('apps')
local Window = require('system/window')
local Timer = require('system/timer')

gScrollIncrement = Window.OSFont:getHeight() * 5
gClickedThisFrame = false
gDoubleClickedThisFrame = false
love.audio.setVolume(0.5)
love.mouse.setVisible(false)
love.keyboard.setKeyRepeat(true)

function executeFile(filename,data)
    local splitOnDot = filename:split('.')
    local format = splitOnDot[#splitOnDot]

    if format == 'txt' then
        LaunchApp('textboy',filename)
    end

    if format == 'exe' then
        LaunchApp(data.app)
    end


    if format == 'png' then
        LaunchApp('imageviewer',filename)
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

function getAllStarActorsAndWindows()
    local tuples = {}
    local windows = Window.getAll()
    for i,window in ipairs(windows) do
        if window.scene then
            for j,act in ipairs(window.scene:getAllActors()) do
                if act.star then
                    append(tuples,{actor=act,window=window})
                end
            end
        end
    end
    return tuples
end

-- EVENTS --
-- TODO: create an "events" subfolder?
function jumpScare()
    State:persist('hasSeenJumpScare')

    Timer.new(3,function() LaunchApp('popup','Come back with the keys') end)
end

function logIn()
    State:persist('isLoggedIn')
end

function playLoginSound()
    love.audio.newSource('sounds/login.ogg', 'static'):play()
end
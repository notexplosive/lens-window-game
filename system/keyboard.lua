local Apps = require('apps')
local Window = require('system/window')

function love.keypressed(key, scancode, isrepeat)
    local selectedWindow = nx_AllDrawableObjects[1]
    if selectedWindow.type == Window then
        if key == 'escape' then
            selectedWindow:close()
        else
            selectedWindow:keyPress(key)
        end
    else
        if key == 'escape' then
            LaunchApp('settings')
        end
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

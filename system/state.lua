State = {}

DEBUG = true

State.isLoggedIn = false or DEBUG

-- Sets a flag and then writes it to disk
function State:persist(flagName,bool)
    if bool == nil then
        bool = true
    end

    self[flagName] = bool

    _saveToDisk(flagName,bool)
end

-- helper function, should never be cvalled directly except by State:persist()
function _saveToDisk(flagName,bool)
    local saveData = love.filesystem.read('savefile')
    local newSaveData = ''
    if saveData ~= nil then
        local wroteFlag = false
        local lines = saveData:split('\n')
        for i,line in ipairs(lines) do
            if line ~= flagName or (line == flagName and bool) then
                if line == flagName then
                    wroteFlag = true
                end
                newSaveData = newSaveData .. line .. '\n'
            end
        end

        if not wroteFlag and bool then
            newSaveData = newSaveData .. flagName .. '\n'
        end
    else
        if bool then
            love.filesystem.write('savefile',flagName)
        end
    end

    love.filesystem.write('savefile',newSaveData)
end

return State
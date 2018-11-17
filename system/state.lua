State = {}

DEBUG = false

State.isLoggedIn = false or DEBUG

function State:load()
    local lines = love.filesystem.read('savefile'):split('\n')
    for i,line in ipairs(lines) do
        State[line] = true
    end
end

-- Sets a flag, does not write it to disk
function State:set(flagName,bool)
    if bool == nil then
        bool = true
    end

    self[flagName] = bool
end

function State:get(flagName)
    if self[flagName] == nil then
        return false
    end
    return self[flagName]
end

-- Sets a flag and then writes it to disk
function State:persist(flagName,bool)
    self:set(flagName,bool)

    if bool == nil then
        bool = true
    end

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

if not love.filesystem.getInfo('savefile') then
    love.filesystem.write('savefile','')
end

return State
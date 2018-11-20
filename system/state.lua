State = {}

DEBUG = false

State.isLoggedIn = false or DEBUG

function State:load()
    local lines = love.filesystem.read('savefile'):split('\n')
    for i,line in ipairs(lines) do
        local _,count = line:gsub('=','=')
        if count > 0 then
            local v = line:split('=')
            local varName,val = v[1],v[2]
            State[varName] = val
        else
            State[line] = true
        end
    end
end

-- Sets a flag, does not write it to disk
function State:set(flagName,val)
    if val == nil then
        val = true
    end

    self[flagName] = val
end

function State:get(flagName)
    if self[flagName] == nil then
        return false
    end
    return self[flagName]
end

-- Sets a flag and then writes it to disk
function State:persist(flagName,val)
    self:set(flagName,val)

    if val == nil then
        val = true
    end

    _saveToDisk(flagName,val)
end

function State:fromString(line)
    local _,count = line:gsub('=','=')
    if count > 0 then
        local v = line:split('=')
        local key,value = v[1],v[2]
        return key,value
    else
        return line,true
    end
end

-- helper function, should never be cvalled directly except by State:persist()
function _saveToDisk(flagName,val)
    local saveData = love.filesystem.read('savefile')
    local newSaveData = ''
    if saveData ~= nil then
        local lines = saveData:split('\n')
        for i,line in ipairs(lines) do
            local key,value = State:fromString(line)
            -- If the key matches the new key, we want to not duplicate it
            if key ~= flagName then
                local appendedString = key
                if value ~= true then
                    appendedString = appendedString .. '=' .. value
                end
                newSaveData = newSaveData .. appendedString .. '\n'
            end
        end
    else
        -- create file if it doesn't exist, should be done already but better safe than sorry
        love.filesystem.write('savefile',flagName)
    end

    -- Now append the latest bit of data
    -- A value of false is effectively "delete this"
    if val ~= false then
        newSaveData = newSaveData .. flagName
        if val ~= true then
            newSaveData = newSaveData .. '=' .. val
        end
        newSaveData = newSaveData .. '\n'
    end

    love.filesystem.write('savefile',newSaveData)
end

if not love.filesystem.getInfo('savefile') then
    love.filesystem.write('savefile','')
end

return State
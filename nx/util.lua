nx_AllObjects = {}
nx_AllDrawableObjects = {}
nx_null = {NULL = 'NULL'}

function newObject(obj_t,addToList)
    object = {}
    setmetatable(object, obj_t)
    
    obj_t.__index = obj_t
    object.type = obj_t

    if addToList then
        object.listIndex = #nx_AllObjects + 1
        nx_AllObjects[object.listIndex] = object
        nx_AllDrawableObjects[object.listIndex] = object

        function object:destroy()
            nx_AllObjects[self.listIndex] = nx_null
            nx_AllDrawableObjects[getDrawIndex(self)] = nx_null
        end

        if obj_t.getAll == nil then
            function obj_t.getAll()
                local result = {}
                for i,v in ipairs(nx_AllObjects) do
                    if v.type == obj_t then
                        append(result,v)
                    end
                end
                return result
            end
        end

        if obj_t.getAllDraw == nil then
            function obj_t.getAllDraw()
                local result = {}
                for i,v in ipairs(nx_AllDrawableObjects) do
                    if v.type == obj_t then
                        append(result,v)
                    end
                end
                return result
            end
        end
    end

    return object
end

local Vector = require('nx/vector')

gCameraPos = Vector.new(0,0)
gCameraZoom = 1

function getDrawPos(worldx,worldy)
    if type(worldx) ~= 'number' and worldx.type == Vector then
        local vec = worldx
        return Vector.new(getDrawPos(vec.x,vec.y))
    end

    local x = (worldx + (gCameraPos.x)) * gCameraZoom
    local y = (worldy + (gCameraPos.y)) * gCameraZoom

    return x,y
end

function getDrawIndex(obj)
    for i,v in ipairs(nx_AllDrawableObjects) do
        if obj == v then
            return i
        end
    end

    return nil
end

-- Generic list utility
function append(table,element)
    table[#table + 1] = element
end

-- Generic utility function
function isInList(element,table)
    for i,v in ipairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

-- Generic utility to get a random element of an array
function getRandom(table)
    return table[math.random(#table)]
end
    
-- Taken from SuperFastNinja on StackOverflow
function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function string.charAt(str,i)
    return string.sub(str,i,i)
end

-- Taken from lhf on StackOverflow
function getKeys(table)
    local keyset={}
    local n=0

    for k,v in pairs(table) do
        n=n+1
        keyset[n]=k
    end
    return keyset
end
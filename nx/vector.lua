local Vector = {}

function Vector.new(x,y)
    local vector = newObject(Vector)
    vector.x = x or 0
    vector.y = y or 0
    return vector
end

function Vector.__add(left,right)
    return Vector.new(left.x+right.x,left.y+right.y)
end

function Vector.__sub(left,right)
    return Vector.new(left.x-right.x,left.y-right.y)
end

function Vector.__mul(left,right)
    if type(left) == 'number' then
        return Vector.new(left * right.x,left * right.y)
    end

    if type(right) == 'number' then
        return Vector.new(right * left.x,right * left.y)
    end
end

function Vector.__div(left,right)
    if type(left) == 'number' then
        return Vector.new(right.x / left,right.y / left)
    end

    if type(right) == 'number' then
        return Vector.new(left.x / right,left.y / right)
    end
end

function Vector.__unm(v)
    return Vector.new(-v.x,-v.y)
end

function Vector:clone()
    return Vector.new(self.x,self.y)
end

function Vector:toString()
    return self.x .. ', ' .. self.y
end

function Vector:components()
    return self.x,self.y
end

function Vector:length()
    return math.sqrt((self.x*self.x)+(self.y*self.y))
end

function Vector:normalized()
    local l = self:length()
    if l == 0 then
        return Vector.new(0,0)
    end
    return Vector.new(self.x/l,self.y/l)
end

-- aggregate functions
function Vector.allContents(list)
    local output = {}
    for i,v in ipairs(list) do
        local x,y = v:content()
        output[#output + 1] = x
        output[#output + 1] = y
    end
    return output
end

return Vector
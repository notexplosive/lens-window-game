local moonshine = require('moonshine')
local Vector = require('nx/vector')

function love.update(dt)
    for _,obj in ipairs(nx_AllObjects) do
        if obj.updateFunctions then
            for _,func in ipairs(obj.updateFunctions) do
                func(dt)
            end
        end

        if obj.update then
            obj:update(dt)
        end
    end

    if lastUpdate then lastUpdate(dt) end
end

function _mainDraw()
    if firstDraw then firstDraw() end

    for i=#nx_AllDrawableObjects,1,-1 do
        local obj = nx_AllDrawableObjects[i]
        if obj.drawFunctions then
            for _,func in ipairs(obj.drawFunctions) do
                func()
            end
        end

        if obj.draw then
            if obj.pos then
                local dp = getDrawPos(obj.pos)
                obj:draw(dp.x,dp.y)
            else
                obj:draw()
            end
        end
    end

    if lastDraw then lastDraw() end
end

function love.draw()
    local effect = moonshine(moonshine.effects.scanlines)
    effect.chain(moonshine.effects.crt)

    effect.scanlines.opacity = 0.1
    effect.scanlines.frequency = 400
    effect.crt = 0.005


    if not State:get('shaderEnabled') then
        effect.disable("scanlines")
    end

    if not State:get('CRTshaderEnabled') then
        effect.disable("crt")
    end
    

    if State:get('shaderEnabled') or State:get('CRTshaderEnabled') then
        effect( _mainDraw )
    else
        _mainDraw()
    end
end

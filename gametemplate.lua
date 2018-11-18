local Vector = require('nx/vector')
local AppTemplate = require('apptemplate')
local Scene = require('nx/game/scene')
local GameTemplate = {}

function GameTemplate.new(name,width,height)
    local self = AppTemplate.new(name,width,height)

    self.enabledControlButtons = {true,false,true}
    self.allowResizing = false
    self.singleton = true
    self.showInGames = true

    function self:draw(selected,mp)
        love.graphics.setColor(1,1,1,1)
    end

    function self:update(dt)
    end

    return self
end

return GameTemplate
local Sprite = require('nx/game/assets/sprite')
local Assets = {}

Assets.swordBoy = Sprite.new("images/player_new.png",32,32)
Assets.swordBoy:createAnimation('run',1,7)
Assets.swordBoy:createAnimation('stop',1,1)

return Assets
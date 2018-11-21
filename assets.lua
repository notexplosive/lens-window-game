local Sprite = require('nx/game/assets/sprite')
local Assets = {}

Assets.swordBoy = Sprite.new("images/player_new.png",32,32)
Assets.swordBoy:createAnimation('stop',1,1)
Assets.swordBoy:createAnimation('run',1,7)
Assets.swordBoy:createAnimation('jump',9,9)
Assets.swordBoy:createAnimation('fall',10,10)

Assets.bow = Sprite.new('images/bow.png',64,64)
Assets.arrow = Sprite.new('images/arrow.png',64,64)
Assets.target = Sprite.new('images/target.png',64,64)
Assets.fan = Sprite.new('images/fan.png',64,64)
Assets.fan:createAnimation('all',1,5)

Assets.keys = Sprite.new('images/keys.png',64,64)
Assets.keys:createAnimation('all',1,3)
Assets.lock = Sprite.new('images/locks.png',64,64)

return Assets

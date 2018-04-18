
local size = cc.Director:getInstance():getWinSize()

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene:ctor()

end
function GameScene.create()
    local scene = GameScene.new()
    local layer = scene:createLayer()
    scene:addChild(layer)
    return scene
end




function GameScene:createLayer()
    cclog("GameScene init")
    local layer = cc.Layer:create()

    local sprite = cc.Sprite:create("test.png")
    sprite:setPosition(cc.p(size.width/2, size.height/2))
    layer:addChild(sprite)
    
  
  local player = cc.Sprite:create("ship.png")
    player:setPosition(cc.p(size.width/5, size.height/2))
    layer:addChild(player)

    return layer
end

return GameScene


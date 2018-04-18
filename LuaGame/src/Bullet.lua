local size = cc.Director:getInstance():getWinSize()

local Bullet = class("Player", function() 
    return cc.Node:create()
  end)

--建構式
function Bullet:ctor()
  
  
end


function Bullet:addSprite(filePath)
  local sprite = cc.Sprite:create(filePath)
  local body = cc.PhysicsBody:createBox(sprite:getContentSize())
  sprite:setName("bullet")
  sprite:setPhysicsBody(body)
  --body:setCategoryBitmask(1)
  body:setCollisionBitmask(3)
  body:setContactTestBitmask(1)
  body:setGravityEnable(false)
  --sprite:setPosition(cc.p(100,100))
  self:addChild(sprite)
end

return Bullet
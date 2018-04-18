
local Enemy = class("Enemy", function() 
    return cc.Node:create()
  end)

function Enemy:ctor()
  self.hpBar = nil
  self.currentHp = nil
   self.maxHp = nil
   self.sprite = nil
end

function Enemy:addSprite(filePath)
  local sprite = cc.Sprite:create(filePath)
  local body = cc.PhysicsBody:createBox(sprite:getContentSize())
  sprite:setName("enemy")
  sprite:setPhysicsBody(body)
  --body:setCategoryBitmask(2)
  body:setCollisionBitmask(1)
  body:setContactTestBitmask(1)
  body:setGravityEnable(false)
  self:addChild(sprite)
  self.sprite = sprite
    local function hpBarEvent(sender,eventType)
    self.currentHp = sender:getPercent()/100.0
    if self.currentHp <= 50 then
      print("Player < 50")
    end
    
  
  end
  
  self.hpBar = ccui.Slider:create()
  self.hpBar:setTouchEnabled(true)
  self.hpBar:setName("HpBar")
  self.hpBar:loadBarTexture("cocosui/sliderTrack.png")--背景底圖
  self.hpBar:loadProgressBarTexture("cocosui/sliderProgress.png")
  self.hpBar:setPosition(sprite:getPositionX(),sprite:getPositionY()-50)
  self.hpBar:addEventListener(hpBarEvent)
  self.hpBar:setPercent(100)--設定目前血量
  self.hpBar:setScale(0.3)
  self:addChild(self.hpBar)
  self.maxHp = self.hpBar:getPercent()
  self.currentHp = self.maxHp 
  
end

function Enemy:takeHit()
  
  self.currentHp = self.currentHp - 100
  self.hpBar:setPercent(self.currentHp)
  
 if self.currentHp <= 0 then
   self:isDead()
  end
  
end

function Enemy:isDead()
  print("enemy is Dead")
  --self.sprite:setVisible(false)
  --self.hpBar:setVisible(false)
self:removeChildByName("enemy")
self:removeChildByName("HpBar")


end


return Enemy

local size = cc.Director:getInstance():getWinSize()

local Player = class("Player", function() 
    return cc.Node:create()
  end)

--建構式
function Player:ctor()
  self.maxHp = nil;
  self.currentHp = nil;
  self.hpBar = nil
end


function Player:addSprite(filePath)
  local sprite = cc.Sprite:create(filePath)
  local body = cc.PhysicsBody:createBox(sprite:getContentSize())
  sprite:setName("Player")
  sprite:setPhysicsBody(body)
  --body:setCategoryBitmask(1)
  body:setCollisionBitmask(1)
  body:setContactTestBitmask(1)
  body:setGravityEnable(false)
  --sprite:setPosition(cc.p(100,100))
  self:addChild(sprite)
  
  local function hpBarEvent(sender,eventType)
    self.currentHp = sender:getPercent()/100.0
    if self.currentHp <= 50 then
      print("Player < 50")
    end
  
  end
  
  self.hpBar = ccui.Slider:create()
  self.hpBar:setTouchEnabled(false)
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

function Player:takeHit()
  
  self.currentHp = self.currentHp - 30
  self.hpBar:setPercent(self.currentHp)
  print("Player Hit")
  if self.currentHp <= 0 then
    self:isDead()
  end
  
end

function Player:isDead()

  self:removeChildByName("Player")
  self:removeChildByName("HpBar")
  local GameOverLayer = require("GameOverLayer")
  local gameover = GameOverLayer:createScene()
  cc.Director:getInstance():replaceScene(gameover)
  print("PlayerClass: isDead()")

end

function Player:addHealth()

  self.currentHp = self.maxHp 
  self.hpBar:setPercent(self.currentHp)

end

return Player


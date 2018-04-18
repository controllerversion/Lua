local size = cc.Director:getInstance():getWinSize()

local Boss = class("Boss", function() 
    return cc.Node:create()
  end)

--建構式
function Boss:ctor()
  self.maxHp = nil;
  self.currentHp = nil;
  self.hpBar = nil
end


function Boss:addSprite(filePath)
  local sprite = cc.Sprite:create(filePath)
  local body = cc.PhysicsBody:createBox(sprite:getContentSize())
  sprite:setName("Boss")
  sprite:setPhysicsBody(body)
  --body:setCategoryBitmask(1)
  body:setCollisionBitmask(4)
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
  self:addChild( self.hpBar)
  self.maxHp =  self.hpBar:getPercent()
  self.currentHp = self.maxHp 
  
end

function Boss:takeHitA()
  
  self.currentHp = self.currentHp - 100
   self.hpBar:setPercent(self.currentHp)
  
  if self.currentHp <= 0 then
    self:isDead()
  end
  
end

function Boss:isDead()

  self:removeChildByName("Boss")
  self:removeChildByName("HpBar")
  local Complete = require("CompleteLayer")
  local completescene = Complete:createScene()
  cc.Director:getInstance():replaceScene(completescene)
  print("Boss: isDead()")
end



return Boss

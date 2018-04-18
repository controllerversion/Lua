local size      = cc.Director:getInstance():getWinSize()
local btnCount  = 0
local GameLayer2 = class("GameLayer2", function()
    return cc.Layer:create()
  end)

--建構式
function GameLayer2:ctor()
    cclog("Game Layer")
    --member
    self.schedulerID       = nil
    self.m_HP_scheduler    = nil
    self.m_boss_scheduler  = nil
    self.m_enemy_scheduler = nil
    self.m_btn_scheduler   = nil
    self.player            = nil
    self.enemy             = nil
    self.boss              = nil
    self.m_enemyCount      = 0
    self.actualY           = 0
    self.m_enemyDeadCount  = 0
    self.m_angle           = 0
    self.m_score           = 0
  --場景生命週期
    local function onNodeEvent(event)
      if     event == "enter"   then
        self:onEnter()
      elseif event == "exit"    then
        self:onExit()
      elseif event == "cleanup" then
        self:cleanup()
    end
  end
  self:registerScriptHandler(onNodeEvent)
end

function GameLayer2:createLayer()
  print("createlayer")
  local layer = GameLayer2:new() --建立新layer
  layer:init()
  return layer
end

--createScene
function GameLayer2:create()
  print("create")
  local scene = cc.Scene:createWithPhysics()
  scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
  layer = GameLayer2:createLayer()
  scene:addChild(layer)

  return scene
  
end

function GameLayer2:Joypadcontrol()
  --設定八方向
    local angle         = self.m_angele 
    local moveNone      = cc.MoveBy:create(0.5,cc.p(0,0))
    local moveRight     = cc.MoveBy:create(0.5,cc.p(5,0))
    local moveRightUp   = cc.MoveBy:create(0.5,cc.p(5,5))
    local moveRightDown = cc.MoveBy:create(0.5,cc.p(5,-5))
    local moveUp        = cc.MoveBy:create(0.5,cc.p(0,5))
    local moveDown      = cc.MoveBy:create(0.5,cc.p(0,-5))
    local moveLeftUp    = cc.MoveBy:create(0.5,cc.p(-5,5))
    local moveLeft      = cc.MoveBy:create(0.5,cc.p(-5,0))
    local moveLeftDown  = cc.MoveBy:create(0.5,cc.p(-5,-5))
    --catch Player Name and Control

    local sp = self:getChildByName("Player")
      if sp      == nil then
      else
        if angle == 0   then
          sp:runAction(moveNone)
        elseif (angle > -22.5 and angle < 22.5)    then
          sp:runAction(moveRight)
        elseif (angle > 22.5 and angle < 67.5)     then
          sp:runAction(moveRightUp)
        elseif (angle >67.5 and angle < 112.5)     then
          sp:runAction(moveUp)
        elseif (angle > 112.5 and angle < 157.5)   then
          sp:runAction(moveLeftUp)
        elseif (angle > 157.5 and angle < 180) 
        or     (angle < -157.5 and angle > -180)   then
          sp:runAction(moveLeft)
        elseif (angle < -112.5 and angle > -157.5) then
          sp:runAction(moveLeftDown)
        elseif (angle < -67.5 and angle > -112.5)  then
          sp:runAction(moveDown)
        elseif (angle < -22.5 and angle > -67.5)   then
          sp:runAction(moveRightDown)
      end
    end
end


function GameLayer2:init()
  cclog("init")
  self:initBG()

  local character = cc.UserDefault:getInstance():getStringForKey("character")
  cclog("GameLayer UserDefault string is %s", ret)

  local Joypad = require("JoyPad")
  joypad = Joypad.new()
  joypad:init()
  self:addChild(joypad,100)
  
  self:buttonClick()
  
  scorelab = cc.Label:createWithSystemFont("Score : 0","Arial", 36)
  scorelab:setPosition(cc.p(size.width/2,size.height - 100))
  self:addChild(scorelab)
  self.m_score = scorelab
  
  local scheduler  = cc.Director:getInstance():getScheduler()
  self.schedulerID = scheduler:scheduleScriptFunc(function()
  self:update()
  self.m_angele    = joypad.m_angle
  self:Joypadcontrol()
  end,0,false)   

  local PlayerClass = require("Player")
  local player      = PlayerClass.new();
  
  if character == "1P" then
    player:addSprite("ship.png")
  else
    player:addSprite("E0.png")
  end
  
  player:setName("Player") 
  player:setPosition(cc.p(100,200))
  self:addChild(player)
  self.player = player
  --產生敵人
  local scheduler2       = cc.Director:getInstance():getScheduler()
  self.m_enemy_scheduler = scheduler2:scheduleScriptFunc(function()
     if self.m_enemyDeadCount <= 3 then
        self:Enemy()
        
      else
        print("Close Scheduler")
        cc.Director:getInstance():getScheduler()
        :unscheduleScriptEntry(self.m_enemy_scheduler)
        cc.Director:getInstance():getScheduler()
        :unscheduleScriptEntry(self.m_HP_scheduler) 
        self:Boss()
      end      
    
  end,3,false)   

  local scheduler_HP  = cc.Director:getInstance():getScheduler()
  self.m_HP_scheduler = scheduler_HP:scheduleScriptFunc(function()
    self:Heart()
  end,4,false)   
   --PhySics Event Check
  local conListener = cc.EventListenerPhysicsContact:create()
  conListener:registerScriptHandler(function(contact) 
      
      print("Collision!!") 
      local node1 = contact:getShapeA():getBody():getNode()    
      local node2 = contact:getShapeB():getBody():getNode()  
  
      local A = node1:getName()
      print("node1 Collision:"..A)
      local B = node2:getName()
      print("node2 Collision:"..B)
       
     if ("Player" == node1:getName() and "enemy"  == node2:getName()) 
     or ("enemy"  == node1:getName() and "Player" == node2:getName())  then 
      
      player:takeHit();
      self.enemy:takeHit()
      --self:removeChildByName("enemy") 
      self.m_enemyDeadCount = self.m_enemyDeadCount + 1
      print("m_enemy Dead Count : "..self.m_enemyDeadCount)
      self.m_score:setString("Score :"..self.m_enemyDeadCount)
   
     elseif ("bullet" == node1:getName() and "enemy"  == node2:getName()) 
     or     ("enemy"  == node1:getName() and "bullet" == node2:getName())  then
    
      self:removeChildByName("bullet")
      self.enemy:takeHit()
      self.m_enemyDeadCount = self.m_enemyDeadCount + 1
      print("m_enemy Dead Count : "..self.m_enemyDeadCount)
      self.m_score:setString("Score :"..self.m_enemyDeadCount)
         
     elseif ("bullet" == node1:getName() and "Boss"   == node2:getName()) 
     or     ("Boss"   == node1:getName() and "bullet" == node2:getName())  then
      
      self.boss:takeHitA()
      self:removeChildByName("bullet")
     
     elseif ("Player" == node1:getName() and "Boss"   == node2:getName()) 
     or     ("Boss"   == node1:getName() and "Player" == node2:getName())  then 
      
      self.boss:takeHitA()
      self.player:takeHit()
      
     elseif ("Player"     == node1:getName() and "bossbullet" == node2:getName()) 
     or     ("bossbullet" == node1:getName() and "Player"     == node2:getName())  then 
      
      if     "bossbullet" == node1:getName() then
        self:removeChild(node1,true)
      elseif "bossbullet" == node2:getName() then
        self:removeChild(node2,true)
      end
      
      self.player:takeHit()
    
     elseif ("Player" == node1:getName() and "heart"  == node2:getName()) 
     or     ("heart"  == node1:getName() and "Player" == node2:getName())  then  
      self.player:addHealth()
      self:removeChildByName("heart")
     end
      
  end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
  cc.Director:getInstance():getEventDispatcher():
  addEventListenerWithSceneGraphPriority(conListener,self)
 
end
function GameLayer2:Heart()
  
  local heartSp = cc.Sprite:create("heart.png")
  heartSp:setName("heart")
  heartSp:setPosition(cc.p(1000,300))
  local heartBody = cc.PhysicsBody:createBox(heartSp:getContentSize())
  heartSp:setPhysicsBody(heartBody)
  --heart == 6
  heartBody:setCollisionBitmask(6)
  heartBody:setContactTestBitmask(1)
  heartBody:setGravityEnable(false)
  self:addChild(heartSp)
  
  local function spriteMoveFinished(sender)
    local spriteMove = sender
    self:removeChild(spriteMove,true)
  end
  heartMoveDone = cc.CallFunc:create(spriteMoveFinished)
  --JumpTo:create(時間,位置,高度,次數)
  local heartMove = cc.JumpTo:create(4,cc.p(0,300),100,4)
  heartSp:runAction(cc.Sequence:create(heartMove,heartMoveDone))
  
end

function GameLayer2:Boss()
  local BossClass = require("Boss")
  local boss = BossClass.new();
  boss:addSprite("E3.png")
  boss:setName("boss") 
  boss:setPosition(cc.p(1000,300))
  self:addChild(boss)
  
  self.boss    = boss
  bossEnter    = cc.MoveTo:create(3,cc.p(800,300))
  bossMoveUp   = cc.MoveTo:create(actualDuration,cc.p(800 , 480))
  bossMoveDown = cc.MoveTo:create(actualDuration,cc.p(800, 0))
  bossMove     = cc.Sequence:create(bossMoveUp,bossMoveDown)
  bossMove     = cc.Sequence:create(bossMoveUp,bossMoveDown)
  repeatFor    = cc.RepeatForever:create(bossMove)
 
  boss:runAction(bossEnter)
  boss:runAction(repeatFor)
  
  local scheduler = cc.Director:getInstance():getScheduler()
  self.m_boss_scheduler = scheduler:scheduleScriptFunc(function()
   self:bossAtack()
  end,1,false)   
  
end

function GameLayer2:Enemy()
    self.m_enemyCount = self.m_enemyCount + 1
    
    local EnemyClass  = require("Enemy")
    enemy = EnemyClass.new();
    enemy:addSprite("E4.png")
    enemy:setName("enemy")
    
    local minY     = enemy:getContentSize().height/2
    local maxY     = size.height - enemy:getContentSize().height/2
    local rangeY   = maxY - minY
    actualY        = (math.random(480) % rangeY) + minY
    
    enemy:setPosition(cc.p(size.width + (enemy:getContentSize().width / 2), actualY))
    self:addChild(enemy,2)
    
    --set enemy move
    minDuration    = 2.0;
    maxDuration    = 4.0;
    rangeDuration  = maxDuration - minDuration;
    actualDuration = (math.random() % rangeDuration) + minDuration;
  
    enemyMove = cc.MoveTo:create(actualDuration,cc.p(0 - enemy:getContentSize().width / 2, actualY))
  ---[[
    local function enemyMoveFinished(sender)
      local spriteMove = sender
      self:removeChild(spriteMove,true)
    end
    enemyMoveDone  = cc.CallFunc:create(enemyMoveFinished)
    enemy:runAction(cc.Sequence:create(enemyMove,enemyMoveDone))
    --]]
    self.enemy     = enemy;
end


function GameLayer2:bossAtack()
  local boss         = self:getChildByName("boss")
  local bossbulletSp = cc.Sprite:create("laser2.png")
  bossbulletSp:setPosition(boss:getPositionX() - 80,boss:getPositionY())
  bossbulletSp:setName("bossbullet")
  local bulletBody   = cc.PhysicsBody:createBox(bossbulletSp:getContentSize())
  bossbulletSp:setPhysicsBody(bulletBody)
    
  --bullet = 3
  bulletBody:setCollisionBitmask(5)
  bulletBody:setContactTestBitmask(1)
  bulletBody:setGravityEnable(false)
    
  bulletMove = cc.MoveBy:create(2,cc.p(-1000,0))
  
  local function spriteMoveFinished(sender)
    local spriteMove = sender
    self:removeChild(spriteMove,true)
  end
  bulletMoveDone     = cc.CallFunc:create(spriteMoveFinished)
  bossbulletSp:runAction(cc.Sequence:create(bulletMove,bulletMoveDone))
  self:addChild(bossbulletSp,5)

end

function GameLayer2:bullet()
    ---[[
    local player     = self:getChildByName("Player")
    local bulletSp   = cc.Sprite:create("laser1.png")
    bulletSp:setPosition(player:getPositionX() + 50,player:getPositionY())
    bulletSp:setName("bullet")
    local bulletBody = cc.PhysicsBody:createBox(bulletSp:getContentSize())
    bulletSp:setPhysicsBody(bulletBody)
    
    --bullet = 3
    bulletBody:setCollisionBitmask(3)
    bulletBody:setContactTestBitmask(1)
    bulletBody:setGravityEnable(false)
    --]]
    
    bulletMove = cc.MoveBy:create(2,cc.p(1000,0))
  
    local function spriteMoveFinished(sender)
      local spriteMove  = sender
      self:removeChild(spriteMove,true)
    end
    bulletMoveDone = cc.CallFunc:create(spriteMoveFinished)
    bulletSp:runAction(cc.Sequence:create(bulletMove,bulletMoveDone))
    self:addChild(bulletSp,5)
  
end

function GameLayer2:buttonClick()
  
  local btnClick = cc.MenuItemImage:create("button-1.png","button-2.png")
  btnClick:registerScriptTapHandler( function() self:btnClickCallback() end)
  btnClick:setPosition(cc.p(size.width - 100,size.height/8))
  
  local btn = cc.Menu:create(btnClick)
  btn:setPosition(cc.p(0,0))
  self:addChild(btn,3)
  
end

function GameLayer2:btnClickCallback()
  
  if     btnCount == 0 then
  btnCount = 1
  local schedulerbtn   = cc.Director:getInstance():getScheduler()
  self.m_btn_scheduler = schedulerbtn:scheduleScriptFunc(function()
  self:bullet()
  end,2,false) 
  print("bntton first : "..btnCount)
  
  elseif btnCount == 1 then
  btnCount = 0
  print("second first : "..btnCount)
  cc.Director:getInstance():getScheduler():
  unscheduleScriptEntry(self.m_btn_scheduler) 
 
  end

end

function GameLayer2:initBG()
  
   m_bg1 = cc.Sprite:create("test.png")
   m_bg1:setPosition(cc.p(size.width/2, size.height/2))
   self:addChild(m_bg1)
   
   m_bg2 = cc.Sprite:create("test.png")
   m_bg2:setPosition(cc.p(size.width/2 + size.width, size.height/2))
   self:addChild(m_bg2)
  
end

--map loop
function GameLayer2:update()

  posX1    = m_bg1:getPositionX()
  posX2    = m_bg2:getPositionX()

  iSpeed   = 1
  posX1    = posX1 - iSpeed
  posX2    = posX2 - iSpeed

  mapSize  = m_bg1:getContentSize()
  
  if posX1 < -mapSize.width/2 then
     posX2 = mapSize.width / 2
     posX1 = mapSize.width + mapSize.width / 2
  end
  
  if posX2 < -mapSize.width/2 then
     posX2 = mapSize.width / 2
     posX1 = mapSize.width + mapSize.width / 2
  end
  
  m_bg1:setPositionX(posX1)
  m_bg2:setPositionX(posX2)

end

function GameLayer2:onEnter() 
   cclog("GameLayer : onEnter")

end

function GameLayer2:onExit()
   cclog("GameLayer : onExit")
   btnCount = 0
   cc.UserDefault:getInstance():setStringForKey("kill", self.m_enemyDeadCount)   
   cc.UserDefault:getInstance():flush()
   
   cc.Director:getInstance():getScheduler()
   :unscheduleScriptEntry(self.m_enemy_scheduler) 
   
   if self.m_boss_scheduler ~= nil then
   cc.Director:getInstance():getScheduler()
   :unscheduleScriptEntry(self.m_boss_scheduler) 
   end
   cc.Director:getInstance():getScheduler()
   :unscheduleScriptEntry(self.schedulerID) 
   
   if self.m_btn_scheduler  ~= nil then
   cc.Director:getInstance():getScheduler()
   :unscheduleScriptEntry(self.m_btn_scheduler) 
  end
  
   if self.m_HP_scheduler   ~= nil then
    cc.Director:getInstance():getScheduler()
   :unscheduleScriptEntry(self.m_HP_scheduler) 
  end
 
end

function GameLayer2:cleanup()
    cclog("GameLayer : cleanup")
end

--log show
local function main()
 print("-----------LuaGameDemo START---------");
end

function __G__TRACKBACK__(msg)
    print("----------------------------------------");
    print("LUA ERROR: " .. tostring(msg) .. "\n");
    print(debug.traceback());
    print("----------------------------------------");
    return msg;
end

--start
xpcall(main, __G__TRACKBACK__);

return GameLayer2

local visibleSize = cc.Director:getInstance():getWinSize()
local pi = 3.1415926
local mJsPos = cc.p(visibleSize.width / 9.6, visibleSize.height/6.4)

local btnCount = 0
--local playerMask = 1


local Practice = class("Practice", function()
    return cc.Layer:create()
  end)

function Practice:ctor()
  self.angle = 1
  
  --Scene life
  local function onNodeEvent(event)
      if event == "enter" then
      self:onEnter()
      elseif event == "exit" then
      self:onExit()
      elseif event == "cleanup" then
      self:cleanup()
      end
  end
  self:registerScriptHandler(onNodeEvent)
end

--模擬createScene
function Practice:createScene()
  print("Practice createScene")
  local scene = cc.Scene:createWithPhysics()
  scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
  layer = Practice:create()
  scene:addChild(layer)
  return scene
end

function Practice:create()
  print("Practice create")
  local layer = Practice:new()
  layer:init()
  return layer
end
  
function Practice:init()
  print("Practice init")
  self:initBG()

  player = cc.Sprite:create("ship.png")
  player:setName("Player") 
  local body = cc.PhysicsBody:createBox(player:getContentSize())
  player:setPhysicsBody(body)
  body:setCollisionBitmask(1)
  body:setContactTestBitmask(1)
  body:setGravityEnable(false)
  player:setPosition(cc.p(visibleSize.width/4,visibleSize.height /2))
  self:addChild(player)
  --]]
  
  scorelab = cc.Label:createWithSystemFont("Score : 0","Arial", 36)
  scorelab:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 100))
  self:addChild(scorelab)
  
  --射擊事件
  self:buttonClick()

--scheduler update background --map loop
  local scheduler = cc.Director:getInstance():getScheduler()
  local schedulerID = nil
  schedulerID = scheduler:scheduleScriptFunc(function()
   self:update()
  
  end,0,false)   

--scheduler update enemy --
  local scheduler2 = cc.Director:getInstance():getScheduler()
  local schedulerID2 = nil
  schedulerID2 = scheduler:scheduleScriptFunc(function()
   self:enemy()
  end,1,false)   
  
  --joystick---begin--------------------------------------------
  --搖桿background
  mJsBg = cc.Sprite:create("joystick_bg.png")
  mJsBg:setPosition(mJsPos)
  self:addChild(mJsBg)
  
  --center
  mJsCenter = cc.Sprite:create("joystick_center.png")
  mJsCenter:setPosition(mJsPos)
  self:addChild(mJsCenter)
  ---TocuhEvent
  local function touchBegan(touch, event)
  print("touchBegan")
  local point = touch:getLocation()
  

  print("x : "..point.x)
  print("y : "..point.y)
    if cc.rectContainsPoint(mJsCenter:getBoundingBox(),touch:getLocation()) then
      return true
    end

    return false
  end
  
  local function touchMoved(touch, event)
    print("touchMove")
    local point = touch:getLocation()
  
    x = point.x - mJsPos.x;
    y = point.y - mJsPos.y;
  
    angle = math.atan2 (y, x) * 180 / pi
    jsBgRadis = mJsBg:getContentSize().width * 0.5
    distanceofTouchPointToCenter = math.sqrt(math.pow(mJsPos.x - point.x,2) + math.pow(mJsPos.y - point.y,2))
  
    if distanceofTouchPointToCenter >= jsBgRadis then
      deltX = x * (jsBgRadis/distanceofTouchPointToCenter);
      deltY = y * (jsBgRadis/distanceofTouchPointToCenter);
      mJsCenter:setPosition(cc.p(mJsPos.x + deltX,mJsPos.y + deltY));
    else
      mJsCenter:setPosition(point)
    end
  
    self.angle = angle
    print("angle = "..angle)
  
    --設定移動八方向
    ---[[
    local moveRight = cc.MoveBy:create(0.5,cc.p(5,0))
    local moveRightUp = cc.MoveBy:create(0.5,cc.p(5,5))
    local moveRightDown = cc.MoveBy:create(0.5,cc.p(5,-5))
    local moveUp = cc.MoveBy:create(0.5,cc.p(0,5))
    local moveDown = cc.MoveBy:create(0.5,cc.p(0,-5))
    local moveLeftUp = cc.MoveBy:create(0.5,cc.p(-5,5))
    local moveLeft = cc.MoveBy:create(0.5,cc.p(-5,0))
    local moveLeftDown = cc.MoveBy:create(0.5,cc.p(-5,-5))
    --catch Player Name and Control
    local sp = self:getChildByName("Player")

    if angle > -22.5 and angle < 22.5 then
      sp:runAction(moveRight)
    elseif angle > 22.5 and angle < 67.5 then
      sp:runAction(moveRightUp)
    elseif angle >67.5 and angle < 112.5 then
      sp:runAction(moveUp)
    elseif angle > 112.5 and angle < 157.5 then
      sp:runAction(moveLeftUp)
    elseif (angle > 157.5 and angle < 180) or (angle < -157.5 and angle > -180) then
      sp:runAction(moveLeft)
    elseif angle < -112.5 and angle > -157.5 then
      sp:runAction(moveLeftDown)
    elseif angle < -67.5 and angle > -112.5 then
      sp:runAction(moveDown)
    elseif angle < -22.5 and angle > -67.5 then
      sp:runAction(moveRightDown)
    
    end
  --]]
  
  end--touchmove--End----------------

  local function touchEnded(touch, event)
    print("touchEnded")
    mJsCenter:setPosition(mJsPos)
  
  end
  
  local listener = cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(touchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED)
  listener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED)
--  listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED)
  local eventDispatcher =  cc.Director:getInstance():getEventDispatcher()
eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
  --joystick---end--------------------------------------------
  
  --PhySics Event Check
  local conListener=cc.EventListenerPhysicsContact:create()
  conListener:registerScriptHandler(function(contact) 
      print("Collision!!") 
      local node1=contact:getShapeA():getBody():getNode()    
      local node2=contact:getShapeB():getBody():getNode()  
      
      local A = node1:getName()
      print("node1 Collision:"..A)
      local B = node2:getName()
      print("node2 Collision:"..B)
    
      --player = 1, enemy = 2, bullet = 3
      --playerBody, enemyBody, bulletBody
     if ("Player" == node1:getName() and "enemy" == node2:getName()) 
     or ("enemy" == node1:getName() and "Player" == node2:getName())  then 
       print("Player is Dead")
     
     elseif ("bullet" == node1:getName() and "enemy" == node2:getName()) 
     or ("enemy" == node1:getName() and "bullet" == node2:getName()) then
         local enemy = self:getChildByName("enemy")
         local part =  cc.ParticleFire:create()
         part:setPosition(enemy:getPositionX(),enemy:getPositionY())
         self:addChild(part,3)
         self:removeChildByName("bullet")
         self:removeChildByName("enemy")
        part:setDuration(0.25)
        part:isAutoRemoveOnFinish()
        
     end
      
      
      
      end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
  cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self)
end


function Practice:initBG()
  
   m_bg1 = cc.Sprite:create("test.png")
   m_bg1:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2))
   self:addChild(m_bg1)
   
   m_bg2 = cc.Sprite:create("test.png")
   m_bg2:setPosition(cc.p(visibleSize.width/2 + visibleSize.width, visibleSize.height/2))
  self:addChild(m_bg2)
  
end

function Practice:update()

  posX1 = m_bg1:getPositionX()
  posX2 = m_bg2:getPositionX()

  iSpeed = 1
  posX1 = posX1 - iSpeed
  posX2 = posX2 - iSpeed

  mapSize = m_bg1:getContentSize()
  
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

function Practice:buttonClick()
  
  local btnClick = cc.MenuItemImage:create("button-1.png","button-2.png")
  btnClick:registerScriptTapHandler( function() self:btnClickCallback() end)   btnClick:setPosition(cc.p(visibleSize.width - 100,visibleSize.height/4))
  
  local btn = cc.Menu:create(btnClick)
  btn:setPosition(cc.p(0,0))
  self:addChild(btn,3)
  
end


function Practice:btnClickCallback()
  
  if btnCount == 0 then
    btnCount = 1
    local schedulerbtn = cc.Director:getInstance():getScheduler()
     schedulerbtnID = nil
    schedulerbtnID = schedulerbtn:scheduleScriptFunc(function()
    self:bullet()
  end,2,false) 
  print("bntton first : "..btnCount)
  
  elseif btnCount == 1 then
  btnCount = 0
  print("second first : "..btnCount)
  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerbtnID) 
 
  end

end


function Practice:bullet()
  
    local bulletSp = cc.Sprite:create("laser1.png")
    bulletSp:setPosition(player:getPositionX() + 50,player:getPositionY())
    bulletSp:setName("bullet")
    local bulletBody = cc.PhysicsBody:createBox(bulletSp:getContentSize())
    bulletSp:setPhysicsBody(bulletBody)
    
    --bullet = 3
    bulletBody:setCollisionBitmask(3)
    bulletBody:setContactTestBitmask(1)
    bulletBody:setGravityEnable(false)
    self:addChild(bulletSp)
    
    bulletMove = cc.MoveBy:create(2,cc.p(1000,0))
  
  local function spriteMoveFinished(sender)
  local spriteMove = sender
  self:removeChild(spriteMove,true)
  end
    bulletMoveDone = cc.CallFunc:create(spriteMoveFinished)
    bulletSp:runAction(cc.Sequence:create(bulletMove,bulletMoveDone))
  self:addChild(bulletSp,5)
  
end

function Practice:enemy()
  local enemySp = cc.Sprite:create("E0.png")
  enemySp:setName("enemy")
  enemyBody = cc.PhysicsBody:createBox(enemySp:getContentSize())
  enemySp:setPhysicsBody(enemyBody)
  enemyBody:setCollisionBitmask(2)
  enemyBody:setContactTestBitmask(1)
  enemyBody:setGravityEnable(false)
  
  local minY = enemySp:getContentSize().height/2
  local maxY = visibleSize.height - enemySp:getContentSize().height/2
  
  local rangeY = maxY - minY
  actualY = (math.random(480) % rangeY) + minY
  
  enemySp:setPosition(cc.p(visibleSize.width + (enemySp:getContentSize().width / 2), actualY))
  self:addChild(enemySp,3)
  
  minDuration = 2.0;

  maxDuration = 4.0;

	rangeDuration = maxDuration - minDuration;
  actualDuration = (math.random() % rangeDuration) + minDuration;
  
 
  enemyMove = cc.MoveTo:create(actualDuration,cc.p(0 - enemySp:getContentSize().width / 2, actualY))
  
    local function enemyMoveFinished(sender)
  local spriteMove = sender
  self:removeChild(spriteMove,true)
  end
    enemyMoveDone = cc.CallFunc:create(enemyMoveFinished)
    enemySp:runAction(cc.Sequence:create(enemyMove,enemyMoveDone))
  

end



function Practice:onEnter() 
   cclog("onEnter")
end

function Practice:onExit()
   cclog("onExit")
   cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
   cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID2)
end

function Practice:cleanup()
    cclog("cleanup")
end


--log show
local function main()
 print("-----------LuaGameDemo---------");
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
return Practice
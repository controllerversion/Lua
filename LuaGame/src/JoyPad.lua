local visibleSize = cc.Director:getInstance():getWinSize()
local pi = 3.1415926
local mJsPos = cc.p(visibleSize.width / 9.6, visibleSize.height/6.4)
local JoyPad = class("JoyPad", function()
    return cc.Node:create()
  end)

function JoyPad:ctor()
  print("JoyPad Ctor")
  self.m_angle = 0
  
end

--模擬createScene
--[[
function JoyPad:createScene()
  print("JoyPad createScene")
  local scene = cc.Scene:create()
  layer = JoyPad:create()
  scene:addChild(layer)
  return scene
end
  --]]
function JoyPad:create()
  print("JoyPad create")
  local layer = JoyPad:new()
  layer:init()
  --self:init()
  return layer
end



function JoyPad:getAngle()
  return self.m_angle
end

  
function JoyPad:init()
  print("JoyPad init")
  
  --background
  mJsBg = cc.Sprite:create("joystick_bg.png")
  mJsBg:setPosition(mJsPos)
  self:addChild(mJsBg)
  
  --center
  mJsCenter = cc.Sprite:create("joystick_center.png")
  mJsCenter:setPosition(mJsPos)
  self:addChild(mJsCenter)
 
    
  local function touchBegan(touch, event)
  print("touchBegan")
  local point = touch:getLocation()
  
 -- print("x : "..point.x)
 -- print("y : "..point.y)
  if cc.rectContainsPoint(mJsCenter:getBoundingBox(),touch:getLocation()) then
    return true
  end

  return false
  end
  
  local function touchMoved(touch, event)
  --  print("touchMove")
    local point = touch:getLocation()
  
    x = point.x - mJsPos.x;
    y = point.y - mJsPos.y;
  
    angle = math.atan2 (y, x) * 180 / pi
    jsBgRadis = mJsBg:getContentSize().width * 0.5
    distanceofTouchPointToCenter = math.sqrt(math.pow(mJsPos.x - point.x,2) + 
    math.pow( mJsPos.y - point.y,2))
  
  if distanceofTouchPointToCenter >= jsBgRadis then
    deltX = x * (jsBgRadis/distanceofTouchPointToCenter);
    deltY = y * (jsBgRadis/distanceofTouchPointToCenter);
    mJsCenter:setPosition(cc.p(mJsPos.x + deltX,mJsPos.y + deltY));
  else
    mJsCenter:setPosition(point)
  end
  
  self.m_angle = angle
  print("JoyPad angle = "..self.m_angle)
  
  end

  local function touchEnded(touch, event)
  --  print("touchEnded")
    mJsCenter:setPosition(mJsPos)
    self.m_angle = 0
  end
    
  local listener = cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(touchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED)
  listener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED)
--  listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED)
  local eventDispatcher =  cc.Director:getInstance():getEventDispatcher()
eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
  
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
return JoyPad

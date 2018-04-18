
local size = cc.Director:getInstance():getWinSize()

local TestLayer = class("TestLayer", function()
    return cc.Layer:create();
end);
 
 function TestLayer:ctor()
  print("test Layer")
  self.num = 20
  self.name = "TestLayer.name"
  
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

function TestLayer:createLayer()
    local layer = TestLayer.new()
    layer:init()
    return layer
end

function TestLayer:create()
  local scene = cc.Scene:create()
  local layer = TestLayer:createLayer()
  scene:addChild(layer)
  return scene
end 

function TestLayer:init()
    print("TestLayer init")
    print(self.num)
    print(self.name)
    
    ---[[
  local startitem = cc.MenuItemFont:create("Start")
  local function startItemCallback(sender)
    cclog("Touch Start Menu Item")
    local GameScene = require("GameLayer")
    local gamescene = GameScene:create()
    cc.Director:getInstance():replaceScene(gamescene)
    
  end
  startitem:registerScriptTapHandler(startItemCallback)
  
  local menu = cc.Menu:create(startitem)
  menu:alignItemsVertically()
  self:addChild(menu)
    --]]
    
end

function TestLayer:onEnter()
  cclog("onEnter")
end
function TestLayer:onExit()
  cclog("onExit")
end
function TestLayer:cleanup()
  cclog("cleanup")
end

return TestLayer

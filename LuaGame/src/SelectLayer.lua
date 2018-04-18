--[[

模仿Cpp專案中的HelloWorld

--]]

local visibleSize = cc.Director:getInstance():getWinSize()

--繼承cc.Layer
local SelectLayer = class("SceneLayer", function()
      return cc.Layer:create()
    end)

--類C++建構式
function SelectLayer:ctor()
--建構成員

--場景生命週期
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

--[[
建立createScene
要轉換到SceneLayer場景時,
    local SceneLayer = require("SceneLayer")
    local scenelayer = SceneLayer:createScene()
    cc.Director:getInstance():replaceScene(scenelayer)
--]]
function SelectLayer:createScene()
  local scene = cc.Scene:create()
  local layer = SelectLayer:create()
  scene:addChild(layer)
  return scene
end

function SelectLayer:create()
    local layer = SelectLayer:new()
    layer:init()
    return layer
end

function SelectLayer:init()
  print("SelectLayer init")
  
  local characterSp1 = cc.Sprite:create("ship.png")
  characterSp1:setPosition(cc.p(350,350))
  self:addChild(characterSp1)
  
  local characterSp2 = cc.Sprite:create("E0.png")
  characterSp2:setPosition(cc.p(600,350))
  self:addChild(characterSp2)
  
  local Character1item = cc.MenuItemFont:create("Character 1")
  Character1item:setPosition(cc.p(100,0))
  local function Character1ItemCallback(sender)
    cclog("Touch Start Menu Item")
          --設定userDefault
      cc.UserDefault:getInstance():setStringForKey("character", "1P")   
      cc.UserDefault:getInstance():flush()
      local ret = cc.UserDefault:getInstance():getStringForKey("character")
      cclog("SelectLayer UserDefault string is %s", ret)
    
    local GameLayer = require("GameLayer")
    local gamelayer = GameLayer:create()
    cc.Director:getInstance():replaceScene(gamelayer)
    
  end
  Character1item:registerScriptTapHandler(Character1ItemCallback)
  
  local Character2item = cc.MenuItemFont:create("Character 2")
  Character2item:setPosition(cc.p(350,0))
  local function Character2ItemCallback(sender)
    cclog("Touch Practice Menu Item")
     
      cc.UserDefault:getInstance():setStringForKey("character", "2P")   
      cc.UserDefault:getInstance():flush()
      local ret = cc.UserDefault:getInstance():getStringForKey("character")
      cclog("SelectLayer UserDefault string is %s", ret)
      
    local GameLayer = require("GameLayer")
    local gamelayer = GameLayer:create()
    cc.Director:getInstance():replaceScene(gamelayer)
  end

  Character2item:registerScriptTapHandler(Character2ItemCallback)
  

  
  local menu = cc.Menu:create(Character1item,Character2item)
  --menu:alignItemsVertically()
  menu:setPosition(cc.p(250,250))
  self:addChild(menu)
  
  
end

function SelectLayer:onEnter()
end

function SelectLayer:onExit()
end

function SelectLayer:cleanup()
end

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

return SelectLayer
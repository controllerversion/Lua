local visibleSize = cc.Director:getInstance():getWinSize()

--繼承cc.Layer
local CompleteLayer = class("CompleteLayer", function()
      return cc.Layer:create()
    end)

--類C++建構式
function CompleteLayer:ctor()
--建構成員

--場景生命週期
    local function onNodeEvent(event)
      if     event == "enter" then
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
function CompleteLayer:createScene()
  local scene = cc.Scene:create()
  local layer = CompleteLayer:create()
  scene:addChild(layer)
  return scene
end

function CompleteLayer:create()
    local layer = CompleteLayer:new()
    layer:init()
    return layer
end

function CompleteLayer:init()
  print("SceneLayer init")
  
  local complete = cc.Label:createWithSystemFont("Complete","Arial", 36)
  complete:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 100))
  
  self:addChild(complete)
  local scorelab = cc.Label:createWithSystemFont("Kill : 0","Arial", 36)
  scorelab:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 400))
  self:addChild(scorelab)
  local kill = cc.UserDefault:getInstance():getStringForKey("kill")
  cclog("UserDefault kill is %s", kill)
  scorelab:setString("Score : "..kill)
  
  local Name = cc.UserDefault:getInstance():getStringForKey("string")
  cclog("UserDefault string is %s", Name)
  local playerName = cc.Label:createWithSystemFont("Player : "..Name,"Arial", 36)
  playerName:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 200))
  self:addChild(playerName)
  
  ---[[
  local nextItem = cc.MenuItemFont:create("Next")
  local function nextItemCallback(sender)
    print("Touch Editbox item")
    local GameLayer2 = require("GameLayer2")
    local gamelayer = GameLayer2:create()
    cc.Director:getInstance():replaceScene(gamelayer)
  end
  nextItem:registerScriptTapHandler(nextItemCallback)
  
  local menu = cc.Menu:create(nextItem)
  --menu:alignItemsVertically()
  menu:setPosition(cc.p(650,100))
  self:addChild(menu)
  
  --]]
  
end

function CompleteLayer:onEnter()
end

function CompleteLayer:onExit()
end

function CompleteLayer:cleanup()
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

return CompleteLayer
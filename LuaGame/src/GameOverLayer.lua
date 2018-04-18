--[[

模仿Cpp專案中的HelloWorld

--]]

local visibleSize = cc.Director:getInstance():getWinSize()

--繼承cc.Layer
local GameOverLayer = class("GameOverLayer", function()
      return cc.Layer:create()
    end)

--類C++建構式
function GameOverLayer:ctor()
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
function GameOverLayer:createScene()
  local scene = cc.Scene:create()
  local layer = GameOverLayer:create()
  scene:addChild(layer)
  return scene
end

function GameOverLayer:create()
    local layer = GameOverLayer:new()
    layer:init()
    return layer
end

function GameOverLayer:init()
  print("SceneLayer init")
  
  local gameover = cc.Label:createWithSystemFont("Game Over","Arial", 36)
  gameover:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 100))
  
  self:addChild(gameover)
  local scorelab = cc.Label:createWithSystemFont("Kill : 0","Arial", 36)
  scorelab:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 300))
  self:addChild(scorelab)
  local kill = cc.UserDefault:getInstance():getStringForKey("kill")
  cclog("UserDefault kill is %s", kill)
  scorelab:setString("Score : "..kill)
  
  
  local Name = cc.UserDefault:getInstance():getStringForKey("string")
  cclog("UserDefault string is %s", Name)
  local playerName = cc.Label:createWithSystemFont("PlayerName : "..Name,"Arial", 36)
  playerName:setPosition(cc.p(visibleSize.width/2,visibleSize.height - 500))
  self:addChild(playerName)
  
  
end

function GameOverLayer:onEnter()
end

function GameOverLayer:onExit()
end

function GameOverLayer:cleanup()
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

return GameOverLayer
--[[

模仿Cpp專案中的HelloWorld

--]]

local visibleSize = cc.Director:getInstance():getWinSize()

--繼承cc.Layer
local SceneLayer = class("SceneLayer", function()
      return cc.Layer:create()
    end)

--類C++建構式
function SceneLayer:ctor()
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
function SceneLayer:createScene()
  local scene = cc.Scene:create()
  local layer = SceneLayer:create()
  scene:addChild(layer)
  return scene
end

function SceneLayer:create()
    local layer = SceneLayer:new()
    layer:init()
    return layer
end

function SceneLayer:init()
  print("SceneLayer init")
end

function SceneLayer:onEnter()
end

function SceneLayer:onExit()
end

function SceneLayer:cleanup()
end

local function main()
 print("-----------BloodMJLayer START---------");
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

return SceneLayer
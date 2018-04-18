local visibleSize = cc.Director:getInstance():getWinSize()

local NameScene = class("NameScene", function()
    return cc.Layer:create()
    end)
  
function NameScene:ctor()
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

function NameScene:createScene()
  print("NameScene:createScene")
  local scene = cc.Scene:create()
  local layer = NameScene:create()
  scene:addChild(layer)
  return scene
end

function NameScene:create()
    local layer = NameScene:new()
    layer:init()
  
    return layer
end


function NameScene:init()
  

---  Editbox
  local editBoxSize  = cc.size(visibleSize.width - 100, 60)
  local EditName     = nil
  local editText     = ccui.EditBox:create(editBoxSize, ccui.Scale9Sprite:create("green_edit.png"))
  
  --editText:setName("Input")
  editText:setAnchorPoint(0.5,0.5)
  editText:setPosition(cc.p(visibleSize.width/2,visibleSize.height/1.5))
  editText:setFontSize(36)
  editText:setMaxLength(10)
  editText:setFontColor(cc.c4b(124,92,63,255))
  editText:setPlaceHolder("PlayerName")
  --editText:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
  editText:registerScriptEditBoxHandler(function(eventname,sender) 
  self:editboxHandle(eventname,sender) end)
  self:addChild(editText,5)


  local startitem = cc.MenuItemFont:create("Start")
  local function startItemCallback(sender)
    
    if editText:getText() ~= "" then
      
      local SelectLayer = require("SelectLayer")
      local selectlayer = SelectLayer:create()
      scene:removeChildByTag(3)
      scene:addChild(selectlayer)
      
      --local SelectLayer = require("SelectLayer")
      --local selectlayer = SelectLayer:createScene()
      --cc.Director:getInstance():replaceScene(selectlayer)
    else
    
    end
  end
  startitem:registerScriptTapHandler(startItemCallback)

  local menu = cc.Menu:create(startitem)
  menu:alignItemsVertically()
  self:addChild(menu)

end

function NameScene:editboxHandle(strEventName,sender) 
  
    local edit = sender

		if strEventName == "began" then
      
		elseif strEventName == "ended" then

      --設定userDefault
      cc.UserDefault:getInstance():setStringForKey("string", edit:getText())   
      cc.UserDefault:getInstance():flush()
      local ret = cc.UserDefault:getInstance():getStringForKey("string")
      cclog("UserDefault string is %s", ret)
      
		elseif strEventName == "return" then

      
		elseif strEventName == "changed" then

		end
  
  ---Editbox 基本方法
  --[[
    if strEventName == "began" then  
        sender:setText("")                                      
    elseif strEventName == "ended" then  
    
    elseif strEventName == "return" then  
  
    elseif strEventName == "changed" then  

    end 
    --]]
end  


function NameScene:onEnter()
  cclog("onEnter")
end
function NameScene:onExit()
  cclog("onExit")
end
function NameScene:cleanup()
  cclog("cleanup")
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

return NameScene
local size = cc.Director:getInstance():getWinSize()
--m_control = 0
local Joystick = class("Joystick", function()
    return cc.Node:create()
  end)

function Joystick:ctor()
  self.m_control = "str"
end
--[[
function Joystick:create()
  local scene = cc.Scene:create()
  layer = Joystick:createLayer()
  scene:addChild(layer)
  return scene
end

function Joystick:createLayer()
local layer = Joystick:new()
layer:init()
return layer
end

function Joystick:init()
print("init")
end
--]]

function Joystick:getStr()
  
  
 return self.m_control
  
  end

function Joystick:upItemCallback(sender)
  print("Joystick : up")
  self.m_control = "up"
  print("Joystick : "..self.m_control)
end

function Joystick:Control()
  local upitem = cc.MenuItemImage:create("CloseNormal.png","CloseSelected.png")
  upitem:registerScriptTapHandler( function(sender) self:upItemCallback(sender) end)  
  upitem:setPosition(cc.p(size.width/2, size.height/8))
  
  local menu = cc.Menu:create(upitem)
  --menu:alignItemsVertically()
  menu:setPosition(cc.p(0,0))  
  self:addChild(menu)
  
end

return Joystick



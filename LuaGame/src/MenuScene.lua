local size = cc.Director:getInstance():getWinSize()


local MenuScene = class("MenuScene",function()  --繼承Scene
    return cc.Scene:create()
  end)

function MenuScene:ctor()
    self.scene = nil
end


function MenuScene.create()
 -- local self.scene = MenuScene:new()
 -- self.scene:addChild(self.scene:createLayer(),2,2)
 -- return self.scene
  
   scene = MenuScene.new()
  scene:addChild(scene:createLayer(),2,2)
  return scene
  
end

function MenuScene:createLayer()
  cclog("MenuScene init")
  local layer = cc.Layer:create()
  
  local label = cc.Label:createWithSystemFont("MenuScene", "Arial", 36)
  label:setPosition(cc.p(size.width/2,size.height - 100))
  layer:addChild(label)
  
  
  local startitem = cc.MenuItemFont:create("Start")
  local function startItemCallback(sender)
    cclog("Touch Start Menu Item")
    local GameLayer = require("GameLayer")
    local gamelayer = GameLayer:create()
    cc.Director:getInstance():replaceScene(gamelayer)
    
  end
  startitem:registerScriptTapHandler(startItemCallback)
  
  local practiceitem = cc.MenuItemFont:create("Practice")
  local function practiceItemCallback(sender)
  cclog("Touch Practice Menu Item")
  local Practice = require("Practice")
  local pracice = Practice:createScene()
  cc.Director:getInstance():replaceScene(pracice)
  end

  practiceitem:registerScriptTapHandler(practiceItemCallback)
  
  local editboxitem = cc.MenuItemFont:create("Editbox")
  local function editboxitemCallback(sender)
    print("Touch Editbox item")
    local NameScene = require("NameScene")
   -- local namescene = NameScene:createScene()
    --cc.Director:getInstance():replaceScene(namescene)
      local nameLayer =  NameScene:create()
      self:removeChildByTag(2)
      nameLayer:setTag(3)
      scene:addChild(nameLayer,2)
      
  
  end
  editboxitem:registerScriptTapHandler(editboxitemCallback)
  
  local menu = cc.Menu:create(startitem,practiceitem,editboxitem)
  menu:alignItemsVertically()
  layer:addChild(menu)
  
  
  return layer
end

return MenuScene


--[[
function MenuScene:createScene()
  local scene = cc.Scene:create()
  local layer = MenuScene:create()
  scene:addChild(layer)
    return scene
  end
  
  function MenuScene:init()
    
      local label = cc.Label:createWithSystemFont("MenuScene", "Arial", 36)
  label:setPosition(cc.p(size.width/2,size.height - 100))
  layer:addChild(label)
    
    end
return MenuScene

--]]
--[[


--]]
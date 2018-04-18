

cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
require "cocos.init"
require "cocos.framework.init"
-- cclog
cclog = function(...)
    print(string.format(...))
end


local function main()
    
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)



    local director = cc.Director:getInstance()
    director:getOpenGLView():setDesignResolutionSize(960, 640, 0)

    
    director:setDisplayStats(true)

    
    director:setAnimationInterval(1.0 / 60)
--require('mobdebug').start()
  
  --local scene = require("NameScene")
  --local NameScene = scene.create()
    local scene = require("MenuScene")
    local MenuScene = scene.create()

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(MenuScene)
    else
        cc.Director:getInstance():runWithScene(MenuScene)
    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end

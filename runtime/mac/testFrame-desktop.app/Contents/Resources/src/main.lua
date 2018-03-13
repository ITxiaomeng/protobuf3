
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "src.init"

local function main()
    LayerManager.pushModule("src/app/layers/TestLayer.lua")
end

function __G__TRACKBACK__( msg )
	print("==========================")
	print("LUA ERROR:"..tostring(msg))
	print(debug.traceback())
	print("==========================")
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

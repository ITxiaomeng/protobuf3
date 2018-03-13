
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "src.init"

local function main()
    -- LayerManager.pushModule("MainScene", "src/app/layers/TestLayer.lua", {})
    -- sf.createPop("TestLayer2", "src/app/layers/TestLayer2.lua", {})

    local pbFilePath = "proto/test.pb"
    release_print("PB file path: "..pbFilePath)
    
    local buffer = read_protobuf_file_c(pbFilePath)
    protobuf.register(buffer) --注:protobuf 是因为在protobuf.lua里面使用module(protobuf)来修改全局名字
	local params = {
	    floatVec = {0.1, 0.2, 0.3},
	    intVec = {2,3,4,5,6}
	}
    local stringbuffer = protobuf.encode("vec", params)
    
    
    local slen = string.len(stringbuffer)
    release_print("slen = "..slen)
    
    local temp = ""
    for i=1, slen do
        temp = temp .. string.format("0xX, ", string.byte(stringbuffer, i))
    end
    release_print(temp)
    local result = protobuf.decode("vec", stringbuffer)
    dump(result, "result")
   	
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

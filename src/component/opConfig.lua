local opOperations = {
    -- 中心服务器
	Center_main = 1,    					-- 获取服务器列表
	Center_syncAccount = 8,    			-- 账号信息同步
	Center_syncUser = 9,    				-- 角色信息同步
}

function sf.getOpConfig(name)
    local op = "op=0"
    if opOperations[name] then 
    	op = "op="..tostring(opOperations[name])
    	GAME_OP = tostring(opOperations[name])
    end
	return op
end

-------socket 协议-------
local ProtocolTable = {
	Login_net = 0, --登录连接
	HEARTBEAT = 100, --心跳
	User_forceOffLine = 600, --强制下线
	User_check = 799, --玩家验证
}

function sf.getProtocolConfig(name)
    local op = 0
    if ProtocolTable[name] then 
    	op = ProtocolTable[name]
    end
	return op
end


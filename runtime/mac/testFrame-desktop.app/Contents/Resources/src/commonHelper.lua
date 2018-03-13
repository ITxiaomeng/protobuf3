--[[
    一些方法的封装
]]

function sf.simpleDownload(params)

    local successCallback = params.successCallback
    local failCallback = params.failCallback
    local url = params.url
    local path = params.path or ""

    local request = cc.XMLHttpRequest:new()

    request.timeout = 5

    -- request.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER
    -- request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    -- request.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    request.responseType = cc.XMLHTTPREQUEST_RESPONSE_BLOB
    -- request.responseType = cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT

    request:open("GET", url)

    print("发送开始 - downloadFunc", url)


    local function onReadyStateChanged(  )
        if request.readyState == 4 and (request.status >= 200 and request.status < 207) then -- 服务器返回，应该是要自己定义的
            print("发送结束 - downloadFunc", url)

            --保存到可写目录下的download目录
            -- local saveURI =  "download" .. VERSION_CACHE_ID .. "/" .. path

            -- os.prepareDir(saveURI)
            os.prepareDir(path)

            -- 新版本
            local response = request.response

            io.writefile(device.writablePath .. path, response)

            if successCallback then successCallback() end
        else
            if failCallback then failCallback() end
        end

        request:unregisterScriptHandler()
    end

    request:registerScriptHandler(onReadyStateChanged)
    request:send()

end


--[[
{
name = "xxx",
callback = function(event)
end
}
name:字符串，事件名称
callback:
    function (event)
    end)
]]
function sf.addEventListener(params)
    local eventName         = params.name
    local callback          = params.callback
    sf.removeEventListener(eventName)
    
    local custom_listener = cc.EventListenerCustom:create(eventName,callback)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(custom_listener, 1)
end

--[[
添加在节点上的监听，如果传入node为nil，走zc.addEventListener
节点上的监听在节点被移掉的时候会自动移掉。
]]
function sf.addEventListenerWithNode(params)
    local eventName         = params.name
    local callback          = params.callback
    local node              = params.node
    
    local custom_listener = cc.EventListenerCustom:create(eventName,callback)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    if node then
        eventDispatcher:addEventListenerWithSceneGraphPriority(custom_listener, node)
    else
        eventDispatcher:addEventListenerWithFixedPriority(custom_listener, 1)
    end
end
--[[
发送自定义的引擎消息
一般用于刷新数据
name: 事件名称
data:携带的数据(在接收时可以使用)
{
name = "xxx",
data = "xxx"
}
]]
function sf.dispatchEvent(params)
    local eventName = params.name
    local data      = params.data

    local event     = cc.EventCustom:new(eventName)
    event.data      = data
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:dispatchEvent(event)
end

--[[--
--获取utf8编码字符串正确长度的方法
]]
function sf.utfstrlen(str)
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end


--判断字符串长度及汉字
function sf.stringLen( str )
    local len  = #str
    local left = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    local t = {}
    local start = 1
    local wordLen = 0
    local strLen = 0
    while len ~= left do
        local tmp = string.byte(str, start)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                break
            end
            i = i - 1
        end
        if i >=2 then
            strLen = 2 + strLen
        else
            strLen = 1 + strLen
        end

        wordLen = i + wordLen
        local tmpString = string.sub(str, start, wordLen)
        start = start + i
        left = left + i
        t[#t + 1] = tmpString
    end

    return strLen, t
end

--秒转成时间("00:00:00", "00:00")
function sf.getTimeHMS(time, timeType)
    local H = math.floor(time/3600)
    local M = math.floor(time/60 - H*60)
    local S = math.floor(time%60)
    local showH = 0
    local showM = 0
    local showS = 0
    if H <= 9 then
        showH = "0"..H
    else
        showH = H
    end
    if M <= 9 then
        showM = "0"..M
    else
        showM = M
    end
    if S <= 9 then
        showS = "0"..S
    else
        showS = S
    end
    local M_S = "00:00" --分秒
    if M == 0 then
        M_S =  "00:"..showS
    else
        M_S = showM..":"..showS
    end

    local H_M = "00:00" --时分
    if H == 0 then
        H_M = "00:"..showM
    else
        H_M = showH..":"..showM
    end

    --timeType(1-->分和秒，2-->小时和分，全部)
    if timeType and timeType == 1 then
        return M_S
    elseif timeType and timeType == 2 then
        return H_M
    else
        return (H_M..":"..showS)
    end
end

-- shake效果
function sf.shake(params)
    print("shake ====== ")
    local delta     = 10
    local time      = 0.1
    local speed     = 0.05
    local shakeNode = params.shakeNode
    if params then
        if params.delta then
            delta = params.delta
        end
        if params.time then
            time = params.time
        end
        if params.speed then
            speed = params.speed
        end
        if params.shakeNode then
            shakeNode = params.shakeNode
        end
    end
    time = math.modf(time*10)
    if time < 1 then
        time = 1
    end

    local _shakePos1 = cc.p(delta*0.5, delta*0.5)
    local _shakePos2 = cc.p(-delta, -delta)
    --[[--防止多个震屏互相叠加]]
    -- self:setPosition(cc.p(0,0))
    shakeNode:runAction(cc.Repeat:create(cc.Sequence:create(
        cc.MoveBy:create(speed*0.5, _shakePos1),
        cc.MoveBy:create(speed, _shakePos2),
        cc.MoveBy:create(speed*0.5, _shakePos1)
    ), time))
end
-- 获取当前内存信息
function sf.getNowCacheInfo()
    local textureCache = cc.Director:getInstance():getTextureCache()
    local memInfo = textureCache:getCachedTextureInfo()
    local _s = string.find(memInfo, "%(")
    _s = tonumber(_s) or 0
    local _e = string.find(memInfo, "MB)")
    _e = tonumber(_e) or 2
    local ueserMem = string.sub(memInfo, _s + 1, _e - 1)
    ueserMem = tonumber(ueserMem) or 0
    print("----now collectMemory : " .. tostring(ueserMem))
    return ueserMem, memInfo
end

local function _releaseMemory( removeCSB )
    if removeCSB then
        local manager = ccs.ArmatureDataManager:getInstance()
        xpcall(function()
            manager:removeAllArmatureFileInfo(true)
            print("!!!!!!!!!!!!!!!!!!!清空所有csb数据成功")
        end,function( ... )
            print("!!!!!!!!!!!!!!!!!!!清空所有csb数据失败")
        end)
    end
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    collectgarbage("collect")
    print("*************清理纹理*************")
end

-- 主动释放不用的spriteframe和texture  addby wangming 20150813 
-- tip : 请谨慎使用, 小心刚加载，还没被引用就被释放掉得情况出现
function sf.collectMemory( isForcible, _sNum, removeCSB )
    local memoryTop = tonumber(_sNum) or 70 
    -- 纯纹理内存控制的最大值，大约为实际内存占用量的一半左右，到达则做释放无用纹理处理，可根据做成变量，不同环境具体调整参数
    if isForcible then
        _releaseMemory(removeCSB)
    else
        local ueserMem = helper.getNowCacheInfo()
        if ueserMem >= memoryTop then
           _releaseMemory(removeCSB)
        end
    end
end


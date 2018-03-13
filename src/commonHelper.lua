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

-- 移除自定义事件
function sf.removeEventListener( eventName )
    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(eventName)
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

-- 扑克牌翻牌效果
-- local x = 20
    -- local y = display.height/2

    -- local function openCard(cardBg,cardFg)
    --     local time = 1
    --     cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)--cocos2d::DisplayLinkDirector::Projection::_2D
    --     cardBg:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(--开始角度设置为0，旋转90度
    --         function()
    --             cardFg:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(1,1,0,270,90,0,0)))--开始角度是270，旋转90度
    --         end
    --     )))
    -- end
     
    -- for i = 1,16 do--创建16张
 --        local cardFg = display.newSprite("poker_1_3.png",x+(i*70),y)--背景牌
 --        self:addChild(cardFg,0)
 --        cardFg:setVisible(false)
 
 --        local cardBg = display.newSprite("poker_0_0.png",x+(i*70),y)--前景牌
 --        self:addChild(cardBg,1)
 
 --        self:runAction(cc.Sequence:create(cc.DelayTime:create(1 + i * 0.5),cc.CallFunc:create(function()
 --            openCard(cardBg,cardFg)
 --        end)))
    -- end

-- 根据弧度求角度
function CC_RADIANS_TO_DEGREES( angle )
    return angle * 57.29577951
end

-- 根据角度求弧度 
function CC_DEGREES_TO_RADIANS( angle )
    return angle * 0.01745329252
end

-- 对所有子对象都使用的方法
function sf.doFuncForAllChildren( sNode, sFunc )
    local function _func_( _node )
        if sFunc then
            sFunc(_node)
        end
        if not tolua.isnull(_node) then
            local _children = _node:getChildren()
            for k,v in pairs(_children) do
                _func_(v)
            end
        end
    end
    _func_(sNode)
end

-- 判断是否点击到
function sf.isNodeContainsPoint( node, touch )
    local point = node:convertToNodeSpace(touch)
    point.x = point.x * node:getScaleX()
    point.y = point.y * node:getScaleY()
    local s = node:getBoundingBox()
    local rect_ = cc.rect(0, 0, s.width, s.height)
    if cc.rectContainsPoint(rect_, point) then
        return true
    else
        return false
    end
end

-- 判断node与node的碰撞
function sf.collisionDetection( node1, node2 )
    return cc.rectIntersectsRect(node1:getBoundingBox(), node2:getBoundingBox())
end

-------------------内存方面的东西-------------------
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


----------------------http请求----------------------
--[[ 
    local defaluts = {
        apiName = "",
        sendType = ,
        params = {},
        successCallback = ,
        failCallback = ,
        errorCallback = ,
        isSilent = ,
    }
]]
function sf.sendHttp( params )
    local _apiName = params.apiName
    local _params = params.params or {}
    local _timeoutForRead = params.timeoutForRead
    local _successCallback = params.successCallback
    local _failCallback = params.failCallback
    local _errorCallback = params.errorCallback
    local _isSilent = params.isSilent
    local _type = params.sendType == nil and 0 or 1

    local _succCall = _type == 1 and _successCallback or function( result )
        if result.status ~= 0 then
            if _failCallback then
                _failCallback()
            end
        else
            if _successCallback then
                _successCallback(result.data)
            end
        end
    end
    
    local paramsStr = ""
    local paramNum = 0
    -- dump(params, "desciption, nesting")
    for k, v in pairs(_params) do
        if paramNum > 0 then
            paramsStr = paramsStr .. "&" .. k .. "=" .. v --string.urlencode(v)
        else
            --第一个
            paramsStr = paramsStr .. k .. "=" .. v
        end
        paramNum = paramNum+1
    end
    local requestPath = sf.getOpConfig(_apiName)
    if paramsStr ~= "" then
        requestPath = requestPath .. "&" .. paramsStr
    end
    local _userId = 0
    if PlayerData then
        _userId = tonumber(PlayerData:getBaseInfoByTag("userId")) or 0 
    end
    -- GAMETOKEN = "23c45b78e418940969ef23999e198680383bbd23"
    requestPath = requestPath .. "&tss="..os.time()
    print("requestPath ======= ", requestPath)

    SFHttp:requestAsyncWithParams({
        url = GAMEAPI.."user".."?",
        postData = requestPath,
        timeoutForRead = _timeoutForRead,
        successCallback = function( data )
            if _succCall then _succCall(data) end
        end,--成功回调
        failedCallback = _failCallback,--失败回调
        errorCallback = _errorCallback,
    })
end

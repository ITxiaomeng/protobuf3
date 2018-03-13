--[[
http网络请求模块.
1.异步请求
2.能设置请求的回调函数
3.网络失败需要提示，且能支持重新请求
]]
--游戏请求地址
-- debug

SFHttp = class("SFHttp")
--请求的方式，默认全部是GET
HTTP_REQUEST_TYPE = {
    GET = 0,
    POST = 1
}

HTTP_RESPONSE_TYPE = {
    JSON = "json",
    PACK = "pack",
    STRING = "string"
}


local function _getMethod(method)
    local _method = "GET"
    if method == HTTP_REQUEST_TYPE.POST then
        _method = "POST"
    end
    return _method
end

function SFHttp:ctor(params)
end

--创建http
function SFHttp:createWithParams(params)
    local http = SFHttp.new(params)
    return http
end


--[[
异步请求网络
@url                     请求的网络地址(完整地址)
@method                  HTTP_REQUEST_TYPE.POST / HTTP_REQUEST_TYPE.GET
@startCallback           请求开始时的回调函数
@successCallback         请求成功的回调
@failedCallback          请求失败的回调
@targetNeedsToRetain     
@postData  
@loadingType             
@loadingNode             loading界面 
@loadingParent           loading界面所在的父容器
@reconnectTimes          网络请求失败后重新连接的次数(0不重新链接)
]]
function SFHttp:requestAsyncWithParams(params)
    print("SFHttp:requestAsyncWithParams")
    local url                 = tostring(params.url)--[[请求的网络地址(完整地址)]]
    local method              = params.method--[[请求的方式]]
    local startCallback       = params.startCallback--[[开始请求时的回调函数]]
    local successCallback     = params.successCallback--[[请求成功的回调函数]]
    local failedCallback      = params.failedCallback--[[请求失败的回调函数(此处的失败一般是指网络超时或者服务器返回的数据无法解析成json)]]
    local errorCallback       = params.errorCallback--[[请求失败的回调函数(此处的失败是指走的错误码的通用处理)]]
    local targetNeedsToRetain = params.targetNeedsToRetain--[[请求时需要被retain的对象]]
    local postData            = params.postData--[[post请求时需要的数据]]
    -- local loadingType         = params.loadingType--[[]]
    -- local loadingNode         = params.loadingNode
    -- local loadingParent       = params.loadingParent
    local reconnectTimes      = params.reconnectTimes--[[如果网络失败，重新连接的次数(0或nil代表不需要重试)]]
    local timeoutForRead      = params.timeoutForRead
    local timeoutForConnect   = params.timeoutForConnect
    -- local encrypt             = params.encrypt
    local responseType        = params.responseType
    -- local isRespose           = params.isRespose

    -- if nil == loadingType       then loadingType = HTTP_LOADING_TYPE.CIRCLE     end
    if nil == method            then method = HTTP_REQUEST_TYPE.POST            end
    if nil == reconnectTimes    then reconnectTimes = 0                         end
    if nil == timeoutForRead    then timeoutForRead = 10                        end
    if nil == timeoutForConnect then timeoutForConnect = 10                     end
    if nil == responseType      then responseType = HTTP_RESPONSE_TYPE.JSON     end
    -- if nil == encrypt           then encrypt = HTTP_ENCRYPT_TYPE.AES            end
    if nil == isGameApi         then isGameApi = true                           end
    
    local runningScene   = cc.Director:getInstance():getRunningScene()
    local _doRequest = nil
    local _failedCallback = function()
        --如果有失败的回调，则需要执行该回调
        if reconnectTimes > 0 then
            reconnectTimes = reconnectTimes - 1
            print("网络请求失败，正在重新连接...重新连接次数还剩下:"..reconnectTimes)
            _doRequest()
        else
            if failedCallback then failedCallback() else sf.tipInfo("network_error!") end
        end
    end
    local _url = url
    _doRequest = function()
        print("开始创建网络请求")
        if not tolua.isnull(targetNeedsToRetain) then targetNeedsToRetain:retain() end
        local xhr = cc.XMLHttpRequest:new()
        xhr.timeoutForConnect = timeoutForConnect
        xhr.timeoutForRead = timeoutForRead
        -- cc.XMLHTTPREQUEST_RESPONSE_STRING       = 0
        -- cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER = 1
        -- cc.XMLHTTPREQUEST_RESPONSE_BLOB         = 2
        -- cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT     = 3
        -- cc.XMLHTTPREQUEST_RESPONSE_JSON         = 4
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING

        if postData then
            print("url="..tostring(_url)..tostring(postData))
        else
            print("postData is nil!")
            return
        end
        xhr:open(_getMethod(method), _url)
        local function onReadyStateChanged()
            if not tolua.isnull(targetNeedsToRetain) then targetNeedsToRetain:release() end
            xhr:unregisterScriptHandler()
            local response = xhr.response
            -- print("SFHttp_response : ", response)
            --[[4:DONE ]]
            if isRespose then
                print("请求出错！！！")
                return
            end
            if xhr.readyState == 4 and xhr.status == 200 then
                local parseJsonFailedCallback = function(msg)
                    print("----------------------------------------")
                    print("LUA ERROR: " .. tostring(msg) .. "\n")
                    
                    print(debug.traceback())
                    print("----------------------------------------")
                    print("网络请求失败，原因是：解析数据出错")
                end
                local data = nil
                local function xpcall_callback()
                    if responseType == HTTP_RESPONSE_TYPE.PACK then
                        -- 只有json
                        -- data = MessagePack.unpack(response)
                    elseif responseType == HTTP_RESPONSE_TYPE.JSON then
                        -- base64
                        -- if encrypt == HTTP_ENCRYPT_TYPE.AES then
                        --     local responseDecode = ""
                        --     local len = string.len(response)
                        --     local step = math.ceil(len / 4)
                        --     for i = 1, 4 do
                        --         local p2 = len - step * (i - 1)
                        --         local p = step * i * -1
                        --         responseDecode = responseDecode .. string.sub(response, p, p2)
                        --     end
                        --     response = crypto.decodeBase64(responseDecode)
                        -- end
                        print("SFHttp_response json: ", response)
                        data = json.decode(response)
                    elseif responseType == HTTP_RESPONSE_TYPE.STRING then
                        print("SFHttp_response string: ", response)
                        data = response
                    end
                end
                xpcall(xpcall_callback, parseJsonFailedCallback)
                if data then
                    -- local status = data.status
                    --[[如果是游戏内的请求，则需要处理status]]
                    -- local function _updateTssTime( data )
                    --     if data.tss and PlayerData then
                    --         xpcall(function()
                    --             -- PlayerData:setTssTime(data.tss)
                    --         end, function() end)
                    --     end
                    -- end
                    
                    if successCallback then
                        print("成功回调不为空")
                        successCallback(data)
                    end
                    
                else
                    print("服务器返回出错，data为空data为空data为空data为空data为空")
                    _failedCallback()
                end
            else
                print("网络请求失败，原因是：网络问题或者服务器返回状态码不对")
                _failedCallback()
            end
        end
        xhr:registerScriptHandler(onReadyStateChanged)
        xhr:send(postData)
    end
    _doRequest()
end


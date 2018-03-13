
GameManager = class("GameManager")
require("src/component/GameController")
function GameManager:ctor( )
	self.socket = nil
    self.socketHost = "192.168.26.142"
    -- self.socketHost = "127.0.0.1"
    self.socketPort = 8282
    self.socketName = "SocketTCP"
    self.instance = nil
    self:setDelegate(GameController)
end

function GameManager:setDelegate( instance )
	self.instance = instance
end

function GameManager:start( params )
	if not self.socket then
		self.socket = SocketTCP:new()
	    self.socket:setName(self.socketName)

	    self.eventDispatcherList = {}

	    self.eventDispatcherList[1] = cc.EventListenerCustom:create(SocketTCP.EVENT_DATA, handler(self, self.onTCPReceive))
		self.eventDispatcherList[2] = cc.EventListenerCustom:create(SocketTCP.EVENT_CLOSE, handler(self, self.onTCPClose))
		self.eventDispatcherList[3] = cc.EventListenerCustom:create(SocketTCP.EVENT_CLOSED, handler(self, self.onTCPClosed))
		self.eventDispatcherList[4] = cc.EventListenerCustom:create(SocketTCP.EVENT_CONNECTED, handler(self, self.onTCPConnected))
		self.eventDispatcherList[5] = cc.EventListenerCustom:create(SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.onTCPError))

		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		for i,v in ipairs(self.eventDispatcherList) do
			eventDispatcher:addEventListenerWithFixedPriority(v, 1)
		end
	end


	if not self.socket.isConnected then

		self.socket:connect(self.socketHost, self.socketPort, true)

        print("Manager:SOCKET_HOST:" .. self.socketHost)
        print("Manager:SOCKET_PORT:" .. self.socketPort)
	end
end

-- 发送table
function GameManager:sendTable( sendData )
    if sendData.m ~= "heart_beat" then
        dump(sendData, "sendData")
    end

    if self.socketHost then
    	if self.socket and self.socket.isConnected then
	        self.socket:send(json.encode(sendData))
	    end

	else
		print("self.socketHost为空·~~~~")
		-- zc.socket.sendTable(sendData)
    end

end

function GameManager:onTCPReceive( event )
	if event.name ~= self.socketName then return end
	local netPacks = json.decode(event.data)
	-- dump(netPacks, "netPacks----")
	-- print("进入onTCPReceive")
	if self.instance then
		self.instance:onTCPReceive(netPacks)
	end
end

function GameManager:onTCPClose( event )
	if event.name ~= self.socketName then return end
    print("Manager:onTCPClose")
end

function GameManager:onTCPClosed( event )
	if event.name ~= self.socketName then return end
    print("Manager:onTCPClosed")
end

function GameManager:onTCPConnected( event )
	if event.name ~= self.socketName then return end
    print("Manager:onTCPConnected")

    self:sendTable({m = "tcp_connect"})
end

function GameManager:onTCPError( event )
	if event.name ~= self.socketName then print("socketName", event.name) return end
    print("Manager:onTCPError")
end
function GameManager:stop( params )
	if not self.socket then return end

    self.socket:close()

    self.socket:disconnect()

    self.socketPort = nil

    self.socketHost = nil

    self.socket = nil

    self.instance = nil
end

function GameManager:clean( )
	print("会进入clean嘛")
	self:stop()
end

return GameManager.new()
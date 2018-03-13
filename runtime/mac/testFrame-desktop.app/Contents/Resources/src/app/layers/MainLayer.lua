
require("src/component/GameManager"):start()   -- TCP连接,应该在进入主场景的时候去执行start()
local MainLayer = class("MainLayer", SceneBase)
local Player = require("src/app/player/Player")

function MainLayer:create( params )
	return MainLayer.new(params)
end

function MainLayer:ctor( params )
	self:initData(params)
	self:initUI()
end

function MainLayer:initData( params )
	
end

function MainLayer:initUI( )
	
end

function MainLayer:addPlayer( data )
	local player = Player:create()
	player:setIndex(data.index)
	local posStr = data.pos
	local posVec = string.split(posStr, ",")
	player:setPosition(cc.p(posVec[1], posVec[2]))
	self:addChild(player)
end

return MainLayer
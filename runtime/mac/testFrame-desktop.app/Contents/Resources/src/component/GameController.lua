--[[
	游戏管理类
]]

GameController = class("GameController")

local GameMain = require("src/app/layers/MainLayer")


function GameController:ctor( params )
	self.index = nil
end

function GameController:onTCPReceive( data )
	dump(data, "GameController:onTCPReceive")
	if data.m == "add" then
		if not self.index then
			self.index = data.data.index
		end
		GameMain:addPlayer(data.data)
	end
end

function GameController:clean( )
	
end

return GameController.new()
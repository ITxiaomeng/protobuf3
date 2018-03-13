--[[
	游戏管理类
]]

GameController = class("GameController")

function GameController:ctor( params )
	
end

function GameController:onTCPReceive( data )
	dump(data, "GameController:onTCPReceive")
end

function GameController:clean( )
	
end

return GameController.new()
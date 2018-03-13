local Player = class("Player", cc.Sprite)

function Player:create( params )
	return Player.new(params)
end

function Player:ctor( params )
	self:initData(params)
	self:initUI(params)
	self.index = nil
end

function Player:initData( params )
	
end

function Player:setIndex( index )
	self.index = index
end

function Player:getIndex( )
	return self.index
end

function Player:initUI( )
	sf:createImageView({
		src = "testframe/res/confirm_btn_cancel_scale9_n.png",
		pos = cc.p(0, 0),
		parent = self
		})
end

return Player
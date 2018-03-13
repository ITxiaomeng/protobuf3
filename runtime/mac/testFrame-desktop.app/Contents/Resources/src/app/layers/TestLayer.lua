
local TestLayer = class("TestLayer", SceneBase)

function TestLayer:create( params )
	return TestLayer.new(params)
end

function TestLayer:ctor( params )
	self:initData(params)
	self:initUI()
end

function TestLayer:initData( params )
	
end

function TestLayer:initUI()
	sf:createButton({
		text = "进入游戏",
		pos = cc.p(display.width / 2, display.height / 2),
		parent = self,
		listener = function( sender, eventType )
			if eventType == ccui.TouchEventType.ended then
				
			end
		end
		})
end

function TestLayer:clean( )
	
end

return TestLayer
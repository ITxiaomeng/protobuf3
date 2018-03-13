
local RubCardLayer = require("src/ui/RubCardLayer")
-- require("src/component/GameManager"):start() 
local TestLayer = class("TestLayer", SceneBase)

function TestLayer:create( params )
	return TestLayer.new(params)
end

function TestLayer:ctor( params )
	print("TestLayer ctor!")
	self:initData(params)
	self:initUI()
end

function TestLayer:initData( params )
	
end

function TestLayer:initUI()
	local label = cc.Label:create()
	label:setString("我是最下面那层的")
	label:setPosition(cc.p(display.cx, display.cy))
	self:addChild(label)
	self.label = label

	local function endCallback( )
		
	end

	-- local layer = RubCardLayer:create("poker_0_0.png", "poker_1_3.png", display.width / 2, display.height / 2, endCallback)
	-- self:addChild(layer)

	-- sf.sendHttp({
	-- 	apiName = "Center_main",
	-- 	sendType = 1,
	-- 	params = {
	-- 		status = 1,
	-- 		name = "enter",
	-- 	},
	-- 	successCallback = function ( data )
	-- 		print("请求成功")
	-- 		label:setString(tostring(data.url))
	-- 		self.uid = data.uid
	-- 		if data.pos then
	-- 			local posStr = string.split(data.pos, ",")
	-- 			local player = sf.createSprite("res/confirm_btn_cancel_scale9_p.png")
	-- 			player:setPosition(cc.p(tonumber(posStr[1]),tonumber(posStr[1])))
	-- 			self:addChild(player)
	-- 			self.player = player
	-- 			self:doTouchAction()
	-- 		end
	-- 	end
	-- 	})


end

function TestLayer:doTouchAction(  )
	self:setTouchEnabled(true)
	self:onTouch(function ( event )
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			local x = event.x
			local y = event.y
			sf.sendHttp({
				apiName = "Center_main",
				sendType = 1,
				params = {
					status = 1,
					name = "changepos",
					pos = x..","..y
				},
				successCallback = function ( data )
					print("请求成功")
					self.label:setString(tostring(data.url))
					if data.pos then
						local posstr = string.split(data.pos, ",")
						local x = tonumber(posstr[1])
						local y = tonumber(posstr[2])
						self.player:runAction(cc.MoveTo:create(0.2, cc.p(x,y)))
					end
				end
				})
		end
	end)
end

function TestLayer:clean( )
	
end

return TestLayer
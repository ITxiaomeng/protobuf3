
local TestLayer2 = class("TestLayer2", PopBase)

function TestLayer2:create( params )
	return TestLayer2.new(params)
end

function TestLayer2:ctor( params )
	self:initData(params)
	self:initUI()
end

function TestLayer2:initData( params )
	
end

function TestLayer2:initUI( )
	local bg = cc.Sprite:create("res/bg2.jpg")
	self:addContainer(bg)

	-- sf.setGray(bg, true)

	sf.createButton({
		text = "按钮",
		size = cc.size(100, 50),
		pos = cc.p(bg:getContentSize().width / 2, bg:getContentSize().height / 2),
		listener = function ( sender, eventType )
			if eventType == ccui.TouchEventType.ended then
				print("点了一下")
			end
		end,
		parent = bg,
		})
	
	sf.createLabel({
		text = "hhhh",
		pos = cc.p(100, 20),
		outline = true,
		outlineColor = cc.c3b(255, 0, 0, 255),
		parent = bg,
		})

	local textListView = sf.createListView({
        mask = true,
        inertiaScrollEnabled = true,
        bounceEnabled = false,
        size = cc.size(200, 100),
        ap = cc.p(0, 0),
        pos = cc.p(30, 100),
        parent = bg,
        })

    for i = 1, 2 do
        local cellLayout = sf.createLayout({
            size = cc.size(200, 50),
            listener = function ( sender, eventType )
            	if eventType == ccui.TouchEventType.ended then
            		print("点item--")
            	end
            end
            })
        textListView:pushBackCustomItem(cellLayout)
    end

    local params = {
        fileName = 1007,
        actName = "Animation1",
        parentPath = "res/animation/",
        async = true,
        loop = true,
        asyncCallback = function( _armature_, fileName, num )
            _armature_:getAnimation():play("Animation1", -1, 1)
        end
    }
    local armature = sf.createArmature(params)
    -- armature:getAnimation():play("Animation1", -1, 1)
    bg:addChild(armature)
    armature:setPosition(cc.p(300, 50))
    
end

function TestLayer2:clean(  )
    print("进入clean中，TestLayer2")
end

return TestLayer2
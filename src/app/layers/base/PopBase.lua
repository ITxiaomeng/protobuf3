

local PopBase = class("PopBase", cc.Layer  )

local mContainer = nil

function PopBase:addContainer( container )
	mContainer = container
	
	container:setPosition(cc.p(display.width / 2, display.height / 2))
	self:addChild(container)
	--开始注册点击事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
	--触摸结束
	listener:registerScriptHandler(function ( touch, event )
		return true
	end,cc.Handler.EVENT_TOUCH_BEGAN )

    listener:registerScriptHandler(function ( touch, event )
    	
    end,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(function(touch, event)
        local point = self:convertToNodeSpace(touch:getLocation())
        if cc.rectContainsPoint(mContainer:getBoundingBox(), point) then
        else
        	LayerManager:removeLayout(true)
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

	self:setTouchEnabled(true)
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    --给精灵添加点击事件
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function PopBase:getContainer( )
	return mContainer
end

return PopBase

LayerManager = {}

local mBaseLayer = cc.Layer:create()
local popStack = {}
local sceneStack = {}

local mDirector = cc.Director:getInstance()
function LayerManager.pushModule( layerName, path, params )
	local scene = cc.Scene:create()
	local layer = sf.createScene(layerName, path, params)
	scene:addChild(mBaseLayer)
	cc.Director:getInstance():replaceScene(scene)
end

function getBaseLayer( )
	return mBaseLayer
end

function getPopStack( )
	return popStack
end

function getSceneStack( )
	return sceneStack
end

function LayerManager.addLayout( path, params )
	local baseLayer = getBaseLayer()
	if not baseLayer then
		return nil
	end
	local layer = require(path):create(params)
	return LayerManager.addNode(layer, params)
end
-- 增加一个层
function LayerManager.addNode( node, params )
	local baseLayer = getBaseLayer()
	if not baseLayer then
		print("baseLayer为空LayerManager.addNode( node, params )")
		return nil
	end

	local _params = params
	local _layer = node
	local _layerName = params.layerName
	-- 设置layer的名字
	if _layerName then
		_layer:setName(_layerName)
		print("addOne Layer:---", _layerName)
	end

	local isPop = params.isPop == nil and false or params.isPop
	_layer.isPop = isPop

	local _zOrder = params.zOrder or 0
	baseLayer:addChild(_layer, _zOrder)

	local curStack = isPop and getPopStack() or getSceneStack()
	table.insert(curStack, _layer)
	return _layer
end
-- 移除一个pop或者一个scene
function LayerManager.removeLayout( isPop )
	if not getBaseLayer() then
		print("baseLayer为空LayerManager.removeLayout( isPop )")
		return nil
	end
	local curStack = isPop and getPopStack() or getSceneStack()
	local num = isPop and 0 or 1
	local length = curStack and #curStack or 0
	if length > num then   -- 如果是rootLayer,那就不能去移除了
		local pLayer = table.remove(curStack)
		if not tolua.isnull(pLayer) then
			pLayer:clean()    -- 先执行一下clean，然后再销毁该层
			pLayer:removeFromParent()
		end
	end
end

function LayerManager.remvoeToDefaultLayer(  )
	mDirector:popToRootScene()
	if not getBaseLayer() then
		print("baseLayer为空LayerManager.remvoeToDefaultLayer( )")
		return nil
	end

	local popStack = getPopStack() or {}
	local sceneStack = getSceneStack() or {}
	while true do 
		local length = #popStack
		if length > 0 then
			xpcall(function ( )
				local popLayer = table.remove(popStack)
				if not tolua.isnull(popLayer) then
					popLayer:removeFromParent()
				end
			end, function( ) print("移除所有pop出错") end)
		else
			break
		end
	end

	while true do 
		local length = #sceneStack
		if length > 1 then
			xpcall(function ( )
				local sceneLayer = table.remove(sceneStack)
				if not tolua.isnull(sceneLayer) then
					sceneLayer:removeFromParent()
				end
			end, function( ) print("移除所有scene出错") end)
		else
			break
		end
	end
end


function LayerManager.getLayerByName( layerName )
	if not getBaseLayer() then
		print("baseLayer不存在--")
		return nil
	end
	return self.mBaseLayer:getChildByName(layerName) or nil
end



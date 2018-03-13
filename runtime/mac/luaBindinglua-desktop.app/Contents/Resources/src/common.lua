--[[
    主要是一些ui控件的封装
]]
sf = sf or {}

function sf.createScene( layerName, path, params )
	local baseLayer = LayerManager:getBaseLayer()
	if baseLayer then
		local layer = baseLayer:getChildByName(layerName)
		if layer then
			print("======已经存在这个layer了，不能重复添加=====")
			return
		end
		params = params or {}
		params.layerName = layerName
		return LayerManager.addLayout(path, params)
	end

end

function sf.createPop( layerName, path, params )
	params = params or {}
	params.layerName = layerName
	params.isPop = true
	return LayerManager.addLayout(path, params)
end

function sf._runTitleAction( title )
    local titleArray = {
        cc.ScaleTo:create(0.1, 1.5),
        cc.DelayTime:create(0.1),
        cc.ScaleTo:create(0.2, 1.0),
    }
    title:runAction(cc.Sequence:create(titleArray))
end
--- 过万转换数字
-- @param value 转换值
-- @param ntype 转换类型
-- @param divideTen 是否除以10
-- @return 返回转换后的数值
-- @see sf.reverseWan

function sf.getWan( value, ntype )
    ntype = ntype or 1


    value = tonumber(value)

    if type(value) ~= "number" then
        return ""
    end

    if 1 == ntype then -- 房卡
        return ( value > 99999999 and math.floor( value / 10000) .. sf.lang("commonHelper_Million", "万") or value )
    elseif 2 == ntype then -- 钻石
        return ( value > 999999 and math.floor( value / 10000) .. sf.lang("commonHelper_Million", "万") or value )
    elseif 3 == ntype then -- 伤害
        return ( value > 9999 and math.floor( value / 10000) .. sf.lang("commonHelper_Million", "万") or value )
    elseif 4 == ntype then
       
        if value >= 10^8 then

            local integer, decimal = math.modf(value / 10^8)

            if decimal == 0 then
                value = integer .. sf.lang("commonHelper_Billion", "亿")
            else
                value = math.floor(value / 10^6)
                if value % 10 == 0 then
                    value = string.format("%.1f", value/10^2) .. sf.lang("commonHelper_Billion", "亿")    
                else
                    value = string.format("%.2f", value/10^2) .. sf.lang("commonHelper_Billion", "亿")
                end
            end
            
        elseif value >= 10^5 then

            local integer, decimal = math.modf(value / 10^4)
            if decimal == 0 then
                value = integer .. sf.lang("commonHelper_Million", "万")
            else
                value = math.floor(value / 10^2)
                if value % 10 == 0 then
                    value = string.format("%.1f", value/10^2)..sf.lang("commonHelper_Million", "万")
                else
                    value = string.format("%.2f", value/10^2)..sf.lang("commonHelper_Million", "万")
                end
                
            end
        else

            local integer, decimal = math.modf(value)
            if decimal == 0 then
                value = integer
            else
                value = math.floor(value * 10^3) / 10

                if value % 10 == 0 then
                    value = string.format("%.1f", value/10^2)
                else
                    value = string.format("%.2f", value/10^2)
                end
                
            end

        end

        return value
    end
end

--- 数字转换过万
-- @param value 待转换值
-- @return 返回转换后的数值
-- @see sf.getWan

function sf.reverseWan( value )
    if type(value) == "string" then

        if value == "" then
            return ""
        end

        if tonumber(value) then
            return tonumber(value)
        end

        local ratio = 1
        if string.find(value, sf.lang("commonHelper_Billion", "亿")) then
            ratio = 10^8
        elseif string.find(value, sf.lang("commonHelper_Million", "万")) then
            ratio = 10^4
        end

        local wan = 0
        local z1, z2 = string.gsub(value, "[%d]+", function ( a )
            wan = a
        end)

        return tonumber(wan) * ratio

    end
    return value
end

-- 创建一个labelAtlas
function sf.createLabelAtlas( params )
    assert(params.imagName,    "imagName must be include")
    assert(params.fontWidth,   "fontWidth must be include")
    assert(params.fontHeight,  "fontHeight must be include")
    assert(params.firstChar,   "firstChar must be include")

    local text = params.text or 0
    local labelAtlas = cc.LabelAtlas:_create(text,params.imagName, params.fontWidth, params.fontHeight, string.byte(tostring(params.firstChar)))

    if params.tag then
        labelAtlas:setTag(params.tag)
    end

    if params.opacity then
        labelAtlas:setOpacity(params.opacity)
    end

    if params.pos then
        labelAtlas:setPosition(params.pos)
    end

    if params.ap then
        labelAtlas:setAnchorPoint(params.ap)
    end

    if params.parent then
        params.parent:addChild(labelAtlas)
    end

    return labelAtlas

end

--[[
    创建一个BMFont
]]
function sf.createTextBMFont(params)
    local fntLabel = ccui.TextBMFont:create()

    fntLabel:setFntFile(params.src or "")
    
    if params.text then
        fntLabel:setString(params.text)
    end

    if params.tag then
        fntLabel:setTag(params.tag)
    end

    if params.opacity then
        fntLabel:setOpacity(params.opacity)
    end

    if params.pos then
        fntLabel:setPosition(params.pos)
    end

    if params.ap then
        fntLabel:setAnchorPoint(params.ap)
    end

    if params.scale then
        fntLabel:setScale(params.scale)
    end
    
    if params.name then
        fntLabel:setName(params.name)
    end

    if params.zOrder then
        fntLabel:setLocalZOrder(params.zOrder)
    end

    if params.parent then
        params.parent:addChild(fntLabel)
    end

    return fntLabel
end

function sf.createLabel( params )

    local label = ccui.Text:create()

    local color = params.color or display.COLOR_WHITE
    local fontSize = params.fontSize or 18
    local fontName = params.fontName or display.FONT1

    label:setColor(color)
    label:setFontSize(fontSize)
    label:setFontName(fontName)

    if params.text then
        label:setString(params.text)
    end

    if params.pos then
        label:setPosition(params.pos)
    end
    if params.flipX then
        label:setFlippedX(params.flipX)
    end

    if params.ap then
        label:setAnchorPoint(params.ap)
    end

    if params.alignV then -- cc.VERTICAL_TEXT_ALIGNMENT_TOP
        label:setTextVerticalAlignment(params.alignV)
    end

    if params.alignH then -- cc.TEXT_ALIGNMENT_CENTER
        label:setTextHorizontalAlignment(params.alignH)
    end

    if params.name then
        label:setName(params.name)
    end

    if params.tag then
        label:setTag(params.tag)
    end

    if params.opacity then
        label:setOpacity(params.opacity)
    end

    if params.rotate then
        label:setRotation(params.rotate)
    end

    if params.link then
        if(label.setDrawBottomLine) then
            label:setDrawBottomLine(true)
        end
    end

    if params.shadow then

        local shadowSize = cc.size(2, -2)
        if params.shadowSize then
            shadowSize = params.shadowSize
        end
        local shadowColor = cc.c4b(0, 0, 0, 255)
        if params.shadowColor then
            shadowColor = params.shadowColor
        end

        label:enableShadow(shadowColor, shadowSize)
    end

    if params.outline then
    	print("进入outline")
        local outlineSize = 3
        if params.outlineSize then
            outlineSize = params.outlineSize
        end
        local outlineColor = cc.c4b(0, 0, 0, 255)
        if params.outlineColor then
            outlineColor = params.outlineColor
        end

        -- if device.platform == "android" and outlineSize > 1 then
        --     outlineSize = outlineSize - 1
        -- end

        label:enableOutline(outlineColor, outlineSize)
    end

    if params.glow then
        local glowColor = cc.c4b(0, 0, 0, 255)
        if params.glowColor then
            glowColor = params.glowColor
        end
        label:enableGlow(glowColor)
    end

    if params.zOrder then
        label:setLocalZOrder(params.zOrder)
    end

    -- 换行的话
    if params.size then
        label:setTextAreaSize(params.size)
    end


    if params.listener then
       label:setTouchEnabled(true)
       label:addTouchEventListener(function ( sender, eventType )
           if eventType == ccui.TouchEventType.began then
        
           end
           params.listener(sender, eventType)
       end)
    end

    if params.parent then
        params.parent:addChild(label)
    end

    label.actionStringCfg = {
        frontChar = "",
        behindChar = "",
        scaleAction = false,
    }

    function label:setActionString( text1, text2, pattern )
        if tolua.isnull(label) then
            return
        end

        text2 = text2 or ""
        pattern = pattern or ""

        local nodeScheduler = label:getScheduler() -- Node绑定的Scheduler

        if label.labelScheduler then
            nodeScheduler:unscheduleScriptEntry(label.labelScheduler)
            label.labelScheduler = nil
        end


        local oldText1 = ""
        local oldText2 = ""

        -- 三位数
        if pattern ~= "" then
            local oldTextTb = string.split(label:getString(), pattern)
            oldText1 = oldTextTb[1]
            oldText2 = oldTextTb[2] or ""
            if text2 == "" then
                text2 = oldText2
            end
        else
            oldText1 = label:getString()
            oldText2 = ""
        end

        local oldValue1 = tonumber(sf.reverseWan( oldText1 )) -- 老的数据
        local oldValue2 = tonumber(sf.reverseWan( oldText2 )) -- 老的数据

        local newValue1 = tonumber(sf.reverseWan( text1 ) ) -- 新数据
        local newValue2 = tonumber(sf.reverseWan( text2 ) ) -- 新数据

        if (oldValue1 == newValue1 or oldValue1 == nil or newValue1 == nil) and (pattern ~= "" and oldValue2 and newValue2 and oldValue2 == newValue2) then
            return
        end


        local ratio = 0

        if newValue1 - oldValue1 < 0 then
            ratio = math.floor((newValue1 - oldValue1) / 15)
        else
            ratio = math.ceil((newValue1 - oldValue1) / 15)
        end

        if label.actionStringCfg.scaleAction then
            sf._runTitleAction( label ) -- 播放放大动画
        end
        

        local curValue1 = oldValue1


        local labelScheduler = nil

        labelScheduler = nodeScheduler:scheduleScriptFunc(function ( delta )
            curValue1 = curValue1 + ratio

            if tolua.isnull(label) then
                nodeScheduler:unscheduleScriptEntry(labelScheduler)
                return
            end

            -- 开始逻辑判断
            if ratio > 0 then -- 增加

                if newValue1 > curValue1 then

                    label:setString(label.actionStringCfg.frontChar .. sf.getWan(curValue1, 4) .. pattern .. sf.getWan(newValue2, 4) .. label.actionStringCfg.behindChar)
                else
                    nodeScheduler:unscheduleScriptEntry(labelScheduler)
                    label:setString(label.actionStringCfg.frontChar .. sf.getWan(newValue1, 4) .. pattern .. sf.getWan(newValue2, 4) .. label.actionStringCfg.behindChar)
                end
            elseif ratio < 0 then -- 减少
                if newValue1 < curValue1 then
                    label:setString(label.actionStringCfg.frontChar .. sf.getWan(curValue1, 4) .. pattern .. sf.getWan(newValue2, 4) .. label.actionStringCfg.behindChar)
                else

                    nodeScheduler:unscheduleScriptEntry(labelScheduler)
                    label:setString(label.actionStringCfg.frontChar .. sf.getWan(newValue1, 4) .. pattern .. sf.getWan(newValue2, 4) .. label.actionStringCfg.behindChar)
                end

            else -- 相同
                nodeScheduler:unscheduleScriptEntry(labelScheduler)
                label:setString(label.actionStringCfg.frontChar .. sf.getWan(newValue1, 4) .. pattern .. sf.getWan(newValue2, 4) .. label.actionStringCfg.behindChar)
            end

        end, 0.01, false)

        label.labelScheduler = labelScheduler -- reg

    end


    function label:stopActionText(  )
        local nodeScheduler = label:getScheduler() -- Node绑定的Scheduler
        if label.labelScheduler then
            nodeScheduler:unscheduleScriptEntry(label.labelScheduler)
            label.labelScheduler = nil
        end
    end

    return label
end

-- 创建一个粒子特效
function sf.createParticle( params )
    assert(params.src,    "src must be include")

    local particle = cc.ParticleSystemQuad:create(params.src)

    if params.scale then
        particle:setScale(params.scale)
    end

    if params.remove then
        particle:setAutoRemoveOnFinish(params.remove)
    end

    if params.duration then
        particle:setDuration(params.duration)
    end

    if params.tag then
        particle:setTag(params.tag)
    end

    if params.opacity then
        particle:setOpacity(params.opacity)
    end

    if params.pos then
        particle:setPosition(params.pos)
    end

    if params.ap then
        particle:setAnchorPoint(params.ap)
    end


    if params.parent then
        params.parent:addChild(particle)
    end

    return particle

end


--[[
     --滑动条
        local slider = sf.createSlider({
            barsrc = "res/Image/createroom/progress_bg.png",
            slidballsrc = "res/Image/createroom/progress_ball.png",
            progressbarsrc = "res/Image/createroom/progress_bar.png",
            pos = cc.p(500, sliderHeight ),
            percent = 50,
            parent = bgImg,
            listener = function ( sender, eventType )
                if eventType == ccui.SliderEventType.percentChanged then

                    local score = math.floor(sender:getPercent())

                    if score <= 1 then
                        score = 1
                        sender:setPercent(1)
                    end
                    if score >= 99 then
                        score = 99
                        sender:setPercent(99)
                    end

                    limitLabel:setString(score)

                end
            end
            })
        slider:setScaleX(0.9)
        bgImg.slider = slider
        sf.createButton({
            name = "resduce",
            normal = "res/Image/createroom/resduce_btn.png",
            pressed = "res/Image/createroom/resduce_btn.png",
            ap = cc.p(0.5, 0.5),
            pos = cc.p(- 45, slider:getContentSize().height / 2),
            listener = function(pSender, eventType)
                if eventType == ccui.TouchEventType.ended then
                    slider:setPercent(slider:getPercent() - 1)

                    local score = math.floor(slider:getPercent())

                    if score <= 1 then
                        score = 1
                        slider:setPercent(1)
                    end
                    limitLabel:setString(score)

                end
            end,
            parent = slider,
        })
]]
--创建一个滑动条
function sf.createSlider( params )
    assert(params.barsrc,       "barsrc must be include")
    assert(params.slidballsrc,      "slidballsrc must be include")
    assert(params.progressbarsrc,   "progressbarsrc must be include")

    local slider = ccui.Slider:create()

    slider:loadBarTexture(params.barsrc)
    slider:loadSlidBallTextures(params.slidballsrc, params.slidballsrc, "")
    slider:loadProgressBarTexture(params.progressbarsrc)

    if params.pos then
        slider:setPosition(params.pos)
    end

    if params.ap then
        slider:setAnchorPoint(params.ap)
    end

    if params.zOrder then
        slider:setLocalZOrder(params.zOrder)
    end

    if params.rotate then
        slider:setRotation(params.rotate)
    end

    if params.percent then
        slider:setPercent(params.percent)
    end

    if params.tag then
        slider:setTag(params.tag)
    end

    if params.parent then
        params.parent:addChild(slider)
    end

    if params.listener then
        slider:addEventListener(function ( sender, eventType )
            if eventType == ccui.SliderEventType.percentChanged then

            end
            params.listener(sender, eventType)
        end)

    end

    return slider
end

function sf.createCheckBox(params )

    assert(params.boxSrc,       "boxSrc must be include")
    assert(params.selectSrc,      "selectSrc must be include")

    local checkBox = ccui.CheckBox:create()
    --可点击
    if type(params.touchEnabled) == "boolean" then
        checkBox:setTouchEnabled(params.touchEnabled)
    end
    --是否选中
    if type(params.selected) == "boolean" then
        checkBox:setSelected(params.selected)
    end

    if params.pos then
        checkBox:setPosition(params.pos)
    end

    if params.parent then
        params.parent:addChild(checkBox)
    end

    if params.name then
        checkBox:setName(params.name)
    end

    checkBox:loadTextures(params.boxSrc,params.boxSrc,params.selectSrc, "","",0)

    if params.listener then
        checkBox:addEventListener(function ( sender, eventType )
            params.listener(sender, eventType)
        end)
    end

    return checkBox
end

-- 创建一组单选按钮
function sf.createGroupBtn( params )

    local selectList = {}

    local src_n = params.src_n or "res/Image/createroom/radio_bg.png"
    local src_p = params.src_p or "res/Image/createroom/selected_img.png"

    local checkBox_src = params.checkBox_src or "res/Image/createroom/check_box_bg.png"
    local checkBox_selece_src = params.checkBox_selece_src or "res/Image/createroom/check_box_select.png"

    local startPosX,startPosY = 0,0
    if params.startPos then
        startPosX = params.startPos.x
        startPosY = params.startPos.y
    end

    if params.config then
      --  dump(params.config)
        local freeTime = 0
        local isFree = false
        if DB_STATICTABLE["proto_server_value"]["list"][tostring(params.config.game_type)] then
            freeTime = DB_STATICTABLE["proto_server_value"]["list"][tostring(params.config.game_type)].value
        end
        
        if freeTime and os.time() < tonumber(freeTime) then -- 免费
            isFree = true
        end

        for i,v in ipairs(params.config.game_cfg) do

            startPosY = startPosY - v.margin_h

            sf.createLabel({
                text = v.desc, 
                color = cc.c3b(208, 95, 90),
                ap = cc.p(0,0.5),
                pos = cc.p(startPosX, startPosY),
                fontSize = 28,
                parent = params.parent,
                })



            if v.type == 1 then -- 单选按钮
                local radioGroup = ccui.RadioButtonGroup:create()
                radioGroup:setName(v.name .. "RadioGroup")
                params.parent:addChild(radioGroup)

                for ii,vv in ipairs(v.config) do
                    local row = math.ceil(ii / v.num_limit)
                    local col = (ii-1) % v.num_limit + 1
                    local posX = startPosX + v.radio_offsetX + (col-1) * v.margin_w_inside
                    local posY = startPosY - (row-1) * v.margin_h_inside

                    -- desc
                    local descLabel = sf.createLabel({
                        name = v.name .. "DescLabel" .. ii,
                        text = vv.text, 
                        color = cc.c3b(155, 118, 82),
                        ap = cc.p(0,0.5),
                        pos = cc.p(posX + 30, posY),
                        fontSize = 28,
                        parent = params.parent,
                        })
                    local _type,num = nil, nil

                    local unSeleceColor = cc.c3b(155, 118, 82)
                    local selectColor = cc.c3b(148, 57, 59)

                    local consumeLabel = nil
                    if vv.diamond or vv.money then
                        if vv.diamond then
                            _type = sf.dataTypeGold
                            num = vv.diamond
                        elseif vv.money then
                            _type = sf.dataTypeMoney
                            num = vv.money
                        end

                        if isFree then
                            num = 0
                        end

                        consumeLabel = sf.createAttrLabel({
                            {text = "(", fontSize = 28, color = unSeleceColor, offsetX = 10, offsetY = 0},
                            {image = true, type = _type, scale = 0.6},
                            {text = sf.getWan(num, 4), fontSize = 28, color = unSeleceColor, offsetX = 4, offsetY = 0},
                            {text = ")", fontSize = 28, color = unSeleceColor, offsetX = 2, offsetY = 0},
                            },
                            {
                            name = v.name .. "AttrLabel" .. ii,
                            ap = cc.p(0, 0.5),
                            pos = cc.p(posX + 30 + descLabel:getContentSize().width + 10, posY+5),
                            parent = params.parent,
                            })
                    end

                    local updateConsumeLabel = function( isSelectEd )
                        if consumeLabel then
                            local color = isSelectEd and selectColor or unSeleceColor

                            sf.updateAttrLabel(consumeLabel, {
                                {text = "("},
                                {},
                                {text = sf.getWan(num, 4), color = color},
                                {text = ")"},
                                })
                        end
                    end


                    local radioButton = ccui.RadioButton:create(src_n,src_p)
                    radioButton:setName(v.name .. "RadioBtn" .. ii)
                    radioButton:setPosition(cc.p(posX,posY))
                    radioGroup:addRadioButton(radioButton)
                    params.parent:addChild(radioButton)
                    radioButton:addEventListener(function ( sender, eventType )
                        if eventType == ccui.RadioButtonEventType.selected then
                            descLabel:setColor(selectColor)
                            updateConsumeLabel(true)

                        elseif eventType == ccui.RadioButtonEventType.unselected then
                            descLabel:setColor(unSeleceColor)
                            updateConsumeLabel(false)
                        end
                    end)

                    -- layout
                    local selectLayout = sf.createLayout({
                        name = v.name .. "Layout" .. ii,
                        tag = ii,
                        size = cc.size(v.margin_w_inside - 30, 46),
                        ap = cc.p(0,0.5),
                        pos = cc.p(posX - 20 , posY),
                        parent = params.parent,
                        listener = function ( sender, eventType )
                            if eventType == ccui.TouchEventType.ended then
                                radioGroup:setSelectedButton(ii-1)

                                if radioButton:isSelected() then
                                    descLabel:setColor(selectColor)
                                    updateConsumeLabel(true)
                                else
                                    descLabel:setColor(unSeleceColor)
                                    updateConsumeLabel(false)
                                end

                                if params.events then
                                    local events = params.events
                                    events({config = v, nodeTag = sender:getTag(), nodeName = sender:getName()})
                                end
                            end
                        end
                        })
                    if vv.defaultSelect then
                        radioGroup:setSelectedButton(radioButton)
                    end

                    if radioButton:isSelected() then
                        descLabel:setColor(selectColor)
                        updateConsumeLabel(true)
                    end

                end

                startPosY = startPosY - (math.ceil(#v.config / v.num_limit)-1)*v.margin_h_inside
                
                table.insert(selectList, radioGroup)
            elseif v.type == 2 then -- 多选按钮
                local checkBoxList = {}
                for ii,vv in ipairs(v.config) do
                    local row = math.ceil(ii / v.num_limit)
                    local col = (ii-1) % v.num_limit + 1
                    local posX = startPosX + v.radio_offsetX + (col-1) * v.margin_w_inside
                    local posY = startPosY - (row-1) * v.margin_h_inside


                    -- layout
                    local bgLayout = sf.createLayout({
                        tag = ii,
                        size = cc.size(v.margin_w_inside - 30, 46),
                        ap = cc.p(0, 0.5),
                        pos = cc.p(posX - 20, posY),
                        parent = params.parent,
                        })

                    -- bgLayout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
                    -- bgLayout:setBackGroundColor(display.COLOR_BLACK)
                    -- bgLayout:setBackGroundColorOpacity(50)

                    -- desc
                    local descLabel = sf.createLabel({
                        name = v.name .. "DescLabel" .. ii,
                        text = vv.text, 
                        color = cc.c3b(155, 118, 82),
                        ap = cc.p(0, 0.5),
                        pos = cc.p(60, bgLayout:getContentSize().height / 2),
                        fontSize = 28,
                        parent = bgLayout,
                        })
                    local _type,num = nil, nil
                    if vv.diamond or vv.money then
                        if vv.diamond then
                            _type = sf.dataTypeGold
                            num = vv.diamond
                        elseif vv.money then
                            _type = sf.dataTypeMoney
                            num = vv.money
                        end
                        sf.createAttrLabel({
                            {text = "(", fontSize = 28, color = cc.c3b(155, 118, 82), offsetX = 15, offsetY = 0},
                            {image = true, type = _type, scale = 0.6},
                            {text = sf.getWan(num, 4), fontSize = 28, color = cc.c3b(155, 118, 82), offsetX = 2, offsetY = 0},
                            {text = ")", fontSize = 28, color = cc.c3b(155, 118, 82), offsetX = 5, offsetY = 0},
                            },
                            {
                            name = v.name .. "AttrLabel" .. ii,
                            ap = cc.p(0, 0.5),
                            pos = cc.p(20 + descLabel:getContentSize().width + 10, bgLayout:getContentSize().height / 2+5),
                            parent = bgLayout,
                            })
                    end
                    
                    local checkBox = sf.createCheckBox({
                            name = v.name .. "CheckBox" .. ii,
                            boxSrc = checkBox_src,
                            selectSrc = checkBox_selece_src,
                            selected = vv.selected,
                            pos = cc.p(25, bgLayout:getContentSize().height / 2),
                            parent = bgLayout,
                        })

                    if checkBox:isSelected() then
                        descLabel:setColor(cc.c3b(148, 57, 59))
                    end

                    -- layout
                    local selectLayout = sf.createLayout({
                        name = v.name .. "Layout" .. ii,
                        tag = ii,
                        size = cc.size(v.margin_w_inside - 30, 46),
                        ap = cc.p(0, 0.5),
                        pos = cc.p(0, bgLayout:getContentSize().height / 2),
                        parent = bgLayout,
                        listener = function ( sender, eventType )
                            if eventType == ccui.TouchEventType.ended then
                                checkBox:setSelected(not checkBox:isSelected())
                                if checkBox:isSelected() then
                                    descLabel:setColor(cc.c3b(148, 57, 59))
                                else
                                    descLabel:setColor(cc.c3b(155, 118, 82))
                                end

                                if params.events then
                                    local events = params.events
                                   events({config = v, nodeTag = sender:getTag(), nodeName = sender:getName()})
                                end
                                
                            end
                        end
                        })

                    -- selectLayout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
                    -- selectLayout:setBackGroundColor(display.COLOR_BLACK)
                    -- selectLayout:setBackGroundColorOpacity(200)

                    table.insert(checkBoxList, checkBox)
                    checkBoxList[#checkBoxList].bgLayout = bgLayout
                end

                startPosY = startPosY - (math.ceil(#v.config / v.num_limit)-1)*v.margin_h_inside
    
                table.insert(selectList, checkBoxList)

            end
        end

    end


    return selectList

end
--- 创建Button
-- @param params normalSrc, pressedSrc, size, name, pos, ap, zOrder, listener, tag, actionTag, isDisabled
-- @return 返回Button实例
-- @usage sf.createButton({name = "titleGold", actionTag = sf.dataTypeGold, normal = "Main/mainCity/mainCity_diamond_n.png", <br/>
    -- pressed = "Main/mainCity/mainCity_diamond_h.png", pos = cc.p(0, 20), listener = sf._titleClickCallback})<br/>
function sf.createButton( params )
    local button = ccui.Button:create()

    -- 按钮部分
    local normalSrc = "confirm_btn_cancel_scale9_n.png"
    local pressedSrc = "confirm_btn_cancel_scale9_p.png"
    local disabledSrc = ""
    if params.normal and params.pressed then
        normalSrc = params.normal
        pressedSrc = params.pressed
        disabledSrc = params.disabled or ""
    end

    if params.plist then
        button:loadTextures(normalSrc, pressedSrc, disabledSrc, plist)
    else
        button:loadTextures(normalSrc, pressedSrc, disabledSrc)
    end

    if params.size then
        button:setScale9Enabled(true)
        button:setContentSize(params.size)
    end

    if params.name then
        button:setName(params.name)
    end

    if params.pos then
        button:setPosition(params.pos)
    end

    if params.ap then
        button:setAnchorPoint(params.ap)
    end

    if params.zOrder then
        button:setLocalZOrder(params.zOrder)
    end

    if params.scale then
        button:setScale(params.scale)
    end

    if params.scaleX then
        button:setScaleX(params.scaleX)
    end

    if params.scaleY then
        button:setScaleY(params.scaleY)
    end

    if params.listener then
        button:addTouchEventListener(function ( sender, eventType )

            if params.mask then
                if eventType == ccui.TouchEventType.began then
                    sender.maskImg:setVisible(true)
                elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
                    sender.maskImg:setVisible(false)
                end
            end

            if eventType == ccui.TouchEventType.began then
             
            end

            params.listener(sender, eventType)


        end)

    end
    if params.tag then
        button:setTag(params.tag)
    end
    if params.actionTag then
        button:setActionTag(params.actionTag)
    end

    if params.isDisabled and params.isDisabled == true then
        button:setTouchEnabled(false)
        button:setBright(false)
    end

    -- 图案
    if params.imgSrc then
        local img = ccui.ImageView:create()
        img:loadTexture(params.imgSrc)
        img:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
        button:addChild(img)
    end

    if params.parent then
        params.parent:addChild(button)
    end

    local label = sf.createLabel({
        parent = button,
        pos = cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2),

        text = params.text,
        color = params.fontColor,
        fontSize = params.fontSize,
        fontName = params.fontName,
        link = params.link,
        shadow = params.shadow,
        shadowSize = params.shadowSize,
        shadowColor = params.shadowColor,
        outline = params.outline,
        outlineSize = params.outlineSize,
        outlineColor = params.outlineColor,
        glow = params.glow,
        glowColor = params.glowColor,
        })
    button.label = label -- titleLabel

    function button:setTitleColor( ... )
        label:setColor(...)
    end

    function button:setTitleFontSize( ... )
        label:setFontSize(...)
    end

    function button:setTitleFontName( ... )
        label:setFontName(...)
    end

    function button:setTitleText( ... )
        label:setString(...)
    end

    return button
end
--- 创建Layout
-- @param params pos, size, mask, opacity, listener, name, tag, actionTag,
-- @return Layout实例
-- @usage sf.createLayout({name = "guideDialogReal", size = CCSize(sf.width, sf.height), opacity = 130})
function sf.createLayout( params )
    local layout = ccui.Layout:create()

    if params.scale then
        layout:setScale(params.scale)
    end

    if params.pos then
        layout:setPosition(params.pos)
    end

    if params.ap then
        layout:setAnchorPoint(params.ap)
    end

    if params.size then
        layout:setContentSize(params.size)
    end
    
    if params.listener then
        layout:setTouchEnabled(true)
        layout:addTouchEventListener(function ( sender, eventType )
            if eventType == ccui.TouchEventType.began then
                -- if params.effect then
                --     sf.playEffect(params.effect)
                -- else
                --     sf.playEffect(sf.audioList.effect["click"])
                -- end

            end

            params.listener(sender, eventType)

        end)
    end


    if params.mask then
        layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        layout:setBackGroundColor(display.COLOR_BLACK)
        layout:setBackGroundColorOpacity(100)
        if params.opacity then
            layout:setBackGroundColorOpacity(params.opacity)
        end
        if params.bgColor then
            layout:setBackGroundColor(params.bgColor)
        end

        if params.touchClose then
            layout:setTouchEnabled(true)
            layout:addTouchEventListener(function ( sender, eventType )
                if eventType == ccui.TouchEventType.ended then
                    sender:removeFromParent(true)
                end
            end)
        end
    end

    -- 触摸吞噬
    if type(params.swallowTouches) == "boolean" then
        layout:setSwallowTouches(params.swallowTouches)
    end

    -- 可点击
    if type(params.touchEnabled) == "boolean" then
        layout:setTouchEnabled(params.touchEnabled)
    end

    if params.name then
        layout:setName(params.name)
    end

    if params.tag then
        layout:setTag(params.tag)
    end

    if params.actionTag then
        layout:setActionTag(params.actionTag)
    end

    if params.zOrder then
        layout:setLocalZOrder(params.zOrder)
    end

    if params.parent then
        params.parent:addChild(layout)
    end


    return layout
end
--- 创建ImageView
-- @param params src, pos, ap, scale, flipX, flipY, scale9, size, name, tag, actionTag, listener, opacity ... shaderObj
-- @return 返回ImageView实例
-- @usage local innerBg = sf.createImageView({plist = 1, src = "scale9_inner_bg.png", scale9 = true, size = cc.size(300, 40), pos = cc.p(235, 115)})
function sf.createImageView( params )
    local imageView = ccui.ImageView:create()
    if params.plist then
        imageView:loadTexture(params.src,params.plist)
    else
        imageView:loadTexture(params.src)
    end

    if params.pos then
        imageView:setPosition(params.pos)
    end

    if params.ap then
        imageView:setAnchorPoint(params.ap)
    end

    if params.flipX then
        imageView:setFlippedX(params.flipX)
    end

    if params.flipY then
        imageView:setFlippedY(params.flipY)
    end
    

    if params.scale then
        imageView:setScale(params.scale)
    end

    if params.scaleX then
        imageView:setScaleX(params.scaleX)
    end

    if params.scaleY then
        imageView:setScaleY(params.scaleY)
    end

    if params.scale9 then
        imageView:setScale9Enabled(true)
        if params.capInsets then
            imageView:setCapInsets(params.capInsets)
        end
    end

    if params.size then
        imageView:setContentSize(params.size)
    end
    if params.name then
        imageView:setName(params.name)
    end

    if params.tag then
        imageView:setTag(params.tag)
    end

    if params.actionTag then
        imageView:setActionTag(params.actionTag)
    end

    if params.listener then
        imageView:setTouchEnabled(true)
        imageView:addTouchEventListener(function ( sender, eventType )

            params.listener(sender, eventType)

        end)
    end

    -- 触摸吞噬
    if type(params.swallowTouches) == "boolean" then
        imageView:setSwallowTouches(params.swallowTouches)
    end

    -- 可点击
    if type(params.touchEnabled) == "boolean" then
        imageView:setTouchEnabled(params.touchEnabled)
    end

    if params.opacity then
        imageView:setOpacity(params.opacity)
    end

    if params.gray then
        imageView:setGray(params.gray)
    end

    if params.rotate then
        imageView:setRotation(params.rotate)
    end

    if params.zOrder then
        imageView:setLocalZOrder(params.zOrder)
    end

    -- 以长或宽最小值铺满全屏
    if params.fitScreen then
        local scale = sf.width / imageView:getContentSize().width
        if scale < sf.height / imageView:getContentSize().height then
            scale = sf.height / imageView:getContentSize().height
        end
        imageView:setScale(scale)
    end

    -- 图片是否拉伸全屏
    if params.fullScreen then
        imageView:setScaleX(sf.width / imageView:getContentSize().width)
        imageView:setScaleY(sf.height / imageView:getContentSize().height)
    end

    if params.parent then
        params.parent:addChild(imageView)
    end

    return imageView
end

-- @param params params
-- @return 返回EditBox实例
-- @usage sf.createEditBox({placeHolder = sf.lang("commonHelper_", "输入内容"), ap = cc.p(0, 0.5), size = CCSize(390, 45), pos = cc.p(65, 56),handler = POP.editHandler,fontSize = 24})
function sf.createEditBox( params )

    local bgSrc = params.bgSrc
    local size = params.size or cc.size(160, 35)

    local editBox = ccui.EditBox:create(size, bgSrc)

    local inputMode = params.inputMode or cc.EDITBOX_INPUT_MODE_SINGLELINE -- 默认单行
    local returnType = params.returnType or cc.KEYBOARD_RETURNTYPE_DONE -- 默认DONE
    local fontColor = params.fontColor or display.COLOR_WHITE
    local fontName = params.fontName or display.FONT1
    local placeHolderFontName = params.placeHolderFontName or display.FONT1
    local placeHolderFontSize = params.placeHolderFontSize or params.fontSize
    local placeHolderFontColor = params.placeHolderFontColor or display.COLOR_WHITE

    editBox:setInputMode(inputMode)
    editBox:setReturnType(returnType)
    editBox:setFontColor(fontColor)
    editBox:setFontName(fontName)

    if params.text then
        editBox:setText(params.text)
    end

    if params.pos then
        editBox:setPosition(params.pos)
    end

    if params.ap then
        editBox:setAnchorPoint(params.ap)    
    end

    if params.tag then
        editBox:setTag(params.tag)
    end

    if params.name then
        editBox:setName(params.name)
    end

    if params.fontSize then
        editBox:setFontSize(params.fontSize)
    end

    if params.handler then
        editBox:registerScriptEditBoxHandler(params.handler)
    end

    if params.placeHolder then
        editBox:setPlaceHolder(params.placeHolder)
        editBox:setPlaceholderFontSize(placeHolderFontSize)
        editBox:setPlaceholderFontName(placeHolderFontName)
        editBox:setPlaceholderFontColor(placeHolderFontColor)
    end

    if params.maxLength then
        editBox:setMaxLength(params.maxLength)
    end

    if params.inputFlag then -- cc.EDITBOX_INPUT_FLAG_PASSWORD
        editBox:setInputFlag(params.inputFlag)
    end

    if params.parent then
        params.parent:addChild(editBox)
    end
    
    return editBox

end


function sf.createTextField( params )

    local textField = ccui.TextField:create()

    local color = params.color or display.COLOR_WHITE
    local fontSize = params.fontSize or 26
    local fontName = params.fontName or display.FONT1

    textField:setTextColor(color)
    textField:setFontSize(params.fontSize)
    textField:setFontName(fontName)


    if params.text then
        textField:setString(params.text)
    end

    if params.pos then
        textField:setPosition(params.pos)
    end

    if params.ap then
        textField:setAnchorPoint(params.ap)    
    end

    if params.tag then
        textField:setTag(params.tag)
    end

    if params.name then
        textField:setName(params.name)
    end

    if params.placeHolder then
        textField:setPlaceHolder(params.placeHolder)
    end

    if params.placeHolderColor then
        textField:setPlaceHolderColor(params.placeHolderColor)
    end

    if params.maxLength then
        textField:setMaxLength(params.maxLength)
    end

    if params.touchSize then
        textField:setTouchAreaEnabled(true)
        textField:setTouchSize(params.touchSize)
    end

    if type(params.cursorEnabled) == "boolean" then
        textField:setCursorEnabled(params.cursorEnabled)
    end

    if type(params.passwordEnabled) == "boolean" then
        textField:setPasswordEnabled(params.passwordEnabled)
    end

    if params.parent then
        params.parent:addChild(textField)
    end
    
    return textField

end


-- 创建ProgressTimer
function sf.createProgressTimer( params )

    local src = params.src

    local progressTimer = cc.ProgressTimer:create(cc.Sprite:create(src))

    -- cc.PROGRESS_TIMER_TYPE_RADIAL
    local barType = params.type or cc.PROGRESS_TIMER_TYPE_BAR

    progressTimer:setType(barType)

    if params.midPoint then
        progressTimer:setMidpoint(params.midPoint)
    end

    if params.barChangeRate then
        progressTimer:setBarChangeRate(params.barChangeRate)
    end

    if params.ap then
        progressTimer:setAnchorPoint(params.ap)
    end

    if params.pos then
        progressTimer:setPosition(params.pos)
    end

    if params.percent then
        progressTimer:setPercentage(params.percent)
    end

    if params.scale then
        progressTimer:setScale(params.scale)
    end

    if params.rotate then
        progressTimer:setRotation(params.rotate)
    end

    if params.parent then
        params.parent:addChild(progressTimer)
    end

    if params.tag then
        progressTimer:setTag(params.tag)
    end


    return progressTimer
end

function sf.createScrollView( params )

    local scrollView = ccui.ScrollView:create()

    if params.mask == true then
        scrollView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        scrollView:setBackGroundColor(display.COLOR_WHITE)
        scrollView:setBackGroundColorOpacity(160)
    end
    
    if type(params.scrollBarEnabled) == "boolean" then
        scrollView:setScrollBarEnabled(params.scrollBarEnabled)
    end

    if params.size then
        scrollView:setContentSize(params.size)
    end

    if params.direction then
        scrollView:setDirection(params.direction) -- ccui.ScrollViewDir.vertical/ccui.ScrollViewDir.horizontal
    end

    if type(params.bounceEnabled) == "boolean" then
        scrollView:setBounceEnabled(params.bounceEnabled)
    end

    if type(params.inertiaScrollEnabled) == "boolean" then
        scrollView:setInertiaScrollEnabled(params.inertiaScrollEnabled)
    end

    if params.innerSize then
        scrollView:setInnerContainerSize(params.innerSize)
    end

    if params.pos then
        scrollView:setPosition(params.pos)

    end
    
    if params.ap then
        scrollView:setAnchorPoint(params.ap)
    end

    if params.name then
        scrollView:setName(params.name)
    end

    if params.parent then
        params.parent:addChild(scrollView)
    end

    return scrollView
end
--[[
    local textListView = sf.createListView({
        -- mask = true,
        inertiaScrollEnabled = true,
        bounceEnabled = false,
        size = cc.size(bgView:getContentSize().width - 60, bgView:getContentSize().height - 150),
        ap = cc.p(0, 0),
        pos = cc.p(30, 100),
        parent = bgView,
        })

    for i, v in pairs(CFG) do
        local cellLayout = sf.createLayout({
            tag = i,
            size = cc.size(bgView:getContentSize().width-60, 90),
            listener = POP.quickChatCallback
            })
        textListView:pushBackCustomItem(cellLayout)
        table.insert(listDataTb, cellLayout)

    end
]]
function sf.createListView( params )
    local listView = ccui.ListView:create()

    if params.mask == true then
        listView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        listView:setBackGroundColor(display.COLOR_WHITE)
        listView:setBackGroundColorOpacity(160)
    end

    if type(params.scrollBarEnabled) == "boolean" then
        listView:setScrollBarEnabled(params.scrollBarEnabled)
    end

    if params.size then
        listView:setContentSize(params.size)
    end

    if params.direction then
        listView:setDirection(params.direction) -- ccui.ScrollViewDir.none/ccui.ScrollViewDir.vertical/ccui.ScrollViewDir.horizontal
    end

    if type(params.bounceEnabled) == "boolean" then
        listView:setBounceEnabled(params.bounceEnabled)
    end

    if type(params.inertiaScrollEnabled) == "boolean" then
        listView:setInertiaScrollEnabled(params.inertiaScrollEnabled)
    end

    if type(params.touchEnabled) == "boolean" then
        listView:setTouchEnabled(params.touchEnabled)
    end
    
    if params.pos then
        listView:setPosition(params.pos)
    end
    
    if params.ap then
        listView:setAnchorPoint(params.ap)
    end

    if params.name then
        listView:setName(params.name)
    end

    if params.margin then
        listView:setItemsMargin(params.margin)
    end

    if params.parent then
        params.parent:addChild(listView)
    end

    return listView
end


--- 创建PageView
-- @param params 
-- @return PageView实例
-- @usage sf.createPageView(params)
function sf.createPageView( params )
    local pageView = ccui.PageView:create()

    if params.mask == true then
        pageView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        pageView:setBackGroundColor(display.COLOR_WHITE)
        pageView:setBackGroundColorOpacity(160)
    end

    
    if params.size then
        pageView:setContentSize(params.size)
    end

    if params.direction then
        pageView:setDirection(params.direction) -- ccui.ScrollViewDir.vertical/ccui.ScrollViewDir.horizontal
    end

    if type(params.bounceEnabled) == "boolean" then
        pageView:setBounceEnabled(params.bounceEnabled)
    end

    if type(params.inertiaScrollEnabled) == "boolean" then
        pageView:setInertiaScrollEnabled(params.inertiaScrollEnabled)
    end
    
    if params.pos then
        pageView:setPosition(params.pos)
    end
    
    if params.ap then
        pageView:setAnchorPoint(params.ap)
    end

    if params.name then
        pageView:setName(params.name)
    end

    if params.eventListener then
        pageView:addEventListener(params.eventListener)
    end

    if params.parent then
        params.parent:addChild(pageView)
    end

    return pageView
end


sf.REFRESH_TYPE_NONE_0 = 0 -- 不刷新
sf.REFRESH_TYPE_UP_1 = 1 -- 上拉刷新
sf.REFRESH_TYPE_DOWN_2 = 2 -- 下拉刷新
sf.REFRESH_TYPE_UP_AND_DOWN_3 = 3 -- 上下刷新
--[[
    zc.createTableView({
        bounceEnabled = false,
        inertiaScrollEnabled = true,
        ap = cc.p(0, 0),
        size = cc.size(),
        pos = cc.p(),
        parent = parent,
        scrollBarEnabled = false,
        HANDLER_NUMBER_OF_CELLS_IN_TABLEVIEW = function() end,
        HANDLER_TABLECELL_TOUCHED = function() end,
        HANDLER_TABLECELL_SIZE_FOR_INDEX = function() end,
        HANDLER_TABLECELL_SIZE_AT_INDEX = function() end,
        })
]]
function sf.createTableView( params )

    local tableView = ccui.TableView:create(params.size)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    -- 创建layout，用来显示上拉，下拉刷新
    local refreshShow = sf.createLayout({
        size = params.size,
        })
    local lookNextLabel = sf.createLabel({
        text = "刷新",
        fontSize = 24,
        color = cc.c3b(140, 140, 140),
        ap = cc.p(0.5, 0.5),
        pos = cc.p(params.size.width / 2, 50),
        parent = refreshShow,
        })
    lookNextLabel:setVisible(false)
    tableView.lookNextLabel = lookNextLabel

    local arrowImg = sf.createImageView({
        src = "res/Image/record/record_arrow.png",
        pos = cc.p(params.size.width / 2 - 130,50),
        parent = refreshShow,
        })
    arrowImg:setVisible(false)
    tableView.arrowImg = arrowImg
    if params.maxPage then
        tableView.maxPage = params.maxPage
    end
    
    if params.perPage then
        tableView.perPage = params.perPage
    end

    if params.mask == true then
        tableView:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        tableView:setBackGroundColor(display.COLOR_WHITE)
        tableView:setBackGroundColorOpacity(160)
    end

    if type(params.scrollBarEnabled) == "boolean" then
        tableView:setScrollBarEnabled(params.scrollBarEnabled)
    end

    if params.verticalFillOrder then
        tableView:setVerticalFillOrder(params.verticalFillOrder)
    end

    if params.direction then
        tableView:setDirection(params.direction) -- ccui.ScrollViewDir.vertical/ccui.ScrollViewDir.horizontal
    end

    if params.scrollBarColor then
        tableView:setScrollBarColor(params.scrollBarColor)
    end

    if type(params.bounceEnabled) == "boolean" then
        tableView:setBounceEnabled(params.bounceEnabled)
    end

    if type(params.inertiaScrollEnabled) == "boolean" then
        tableView:setInertiaScrollEnabled(params.inertiaScrollEnabled)
    end
    
    if params.pos then
        refreshShow:setPosition(params.pos)
        tableView:setPosition(params.pos)

    end
    
    if params.ap then
        refreshShow:setAnchorPoint(params.ap)
        tableView:setAnchorPoint(params.ap)
    end

    if params.name then
        tableView:setName(params.name)
    end

    if params.HANDLER_NUMBER_OF_CELLS_IN_TABLEVIEW then
        tableView:registerScriptHandler(params.HANDLER_NUMBER_OF_CELLS_IN_TABLEVIEW, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    end

    if params.HANDLER_TABLECELL_TOUCHED then
        tableView:registerScriptHandler(params.HANDLER_TABLECELL_TOUCHED, cc.TABLECELL_TOUCHED)
    end

    if params.HANDLER_TABLECELL_SIZE_FOR_INDEX then
        tableView:registerScriptHandler(params.HANDLER_TABLECELL_SIZE_FOR_INDEX, cc.TABLECELL_SIZE_FOR_INDEX)
    end

    if params.HANDLER_TABLECELL_SIZE_AT_INDEX then
        tableView:registerScriptHandler(params.HANDLER_TABLECELL_SIZE_AT_INDEX, cc.TABLECELL_SIZE_AT_INDEX)
    end

    if params.zOrder then
        tableView:setLocalZOrder(params.zOrder)
    end

    if params.parent then
        params.parent:addChild(refreshShow)
        params.parent:addChild(tableView)
    end
    
    local rotateState = 0
    if params.pullCallback then

        tableView:addEventListener(function ( sender, eventType )
            if eventType == ccui.ScrollviewEventType.bounceTop and (params.pullType == sf.REFRESH_TYPE_UP_AND_DOWN_3 or params.pullType == sf.REFRESH_TYPE_DOWN_2 ) then

                lookNextLabel:setPosition(cc.p(params.size.width / 2, params.size.height - 50))
                arrowImg:setPosition(cc.p(params.size.width / 2 - 130, params.size.height - 50))

                local innerHeight = sender:getInnerContainerSize().height
                local height = sender:getContentSize().height
                local innerPosY = sender:getInnerContainerPosition().y

                if innerHeight > height then
                    innerPosY = innerHeight - height + sender:getInnerContainerPosition().y
                end

                if innerPosY < -50 and innerPosY > -150 then
                    lookNextLabel:setVisible(true)
                    lookNextLabel:setString("下拉立即加载更多")
                    if rotateState ~= 1 then
                        arrowImg:setVisible(true)
                        arrowImg:stopAllActions()
                        arrowImg:runAction(cc.RotateTo:create(0.3,0))
                        rotateState = 1
                    end
                elseif innerPosY < -150 then
                    lookNextLabel:setString("松开立即加载更多")
                    if rotateState ~= 2 then
                        arrowImg:setVisible(true)
                        arrowImg:stopAllActions()
                        arrowImg:runAction(cc.RotateTo:create(0.3,180))
                        rotateState = 2
                    end
                else
                    rotateState = 0
                    arrowImg:setVisible(false)
                    lookNextLabel:setVisible(false)
                end 


            elseif eventType == ccui.ScrollviewEventType.bounceBottom and (params.pullType == sf.REFRESH_TYPE_UP_AND_DOWN_3 or params.pullType == sf.REFRESH_TYPE_UP_1 ) then
                local height = sender:getContentSize().height
                local innerHeight = sender:getInnerContainerSize().height

                lookNextLabel:setPosition(cc.p(params.size.width / 2, 50))
                arrowImg:setPosition(cc.p(params.size.width / 2 - 130, 50))

                if height < innerHeight and sender.perPage < sender.maxPage then
                    local InnerContainerPosY = sender:getInnerContainerPosition().y

                    if InnerContainerPosY > 50 and InnerContainerPosY < 150 then
                        lookNextLabel:setVisible(true)
                        lookNextLabel:setString("上拉立即加载更多")
                        if rotateState ~= 1 then
                            arrowImg:setVisible(true)
                            arrowImg:stopAllActions()
                            arrowImg:runAction(cc.RotateTo:create(0.3,0))
                            rotateState = 1
                        end
                    elseif InnerContainerPosY >= 150 then
                        lookNextLabel:setString("松开立即加载更多")
                        if rotateState ~= 2 then
                            arrowImg:setVisible(true)
                            arrowImg:stopAllActions()
                            arrowImg:runAction(cc.RotateTo:create(0.3,180))
                            rotateState = 2
                        end
                    else
                        rotateState = 0
                        arrowImg:setVisible(false)
                        lookNextLabel:setVisible(false)
                    end
                    
                else
                    arrowImg:setVisible(false)
                    local InnerContainerPosY = sender:getInnerContainerPosition().y
                    if InnerContainerPosY > 50 then
                        lookNextLabel:setVisible(true)
                        lookNextLabel:setString("已全部加载完毕")
                    else
                        lookNextLabel:setVisible(false)
                    end
                end
            elseif eventType ==  ccui.ScrollviewEventType.autoscrollEnded then
                if sender.canRefresh ~= sf.REFRESH_TYPE_NONE_0 then
                    params.pullCallback(tableView.canRefresh)
                    sender.canRefresh = sf.REFRESH_TYPE_NONE_0
                end
            end
        end)
    end

    if params.pullCallback then
       tableView:setTouchEnabled(true)
       tableView:addTouchEventListener(function ( sender, eventType )
            if eventType == ccui.TouchEventType.ended then

                local innerHeight = sender:getInnerContainerSize().height
                local height = sender:getContentSize().height
                local innerPosY = sender:getInnerContainerPosition().y

                if innerHeight > height then
                    innerPosY = innerHeight - height + sender:getInnerContainerPosition().y
                end

                if innerPosY >= 150 then
                    sender.canRefresh = sf.REFRESH_TYPE_UP_1
                elseif innerPosY <= -150  then
                    sender.canRefresh = sf.REFRESH_TYPE_DOWN_2
                end
            end
       end)
    end
    tableView.canRefresh = sf.REFRESH_TYPE_NONE_0
    return tableView
end


--- 创建LoadingBar
-- @param params src, pos, ap, percent, direction
-- @return LoadingBar实例
-- @usage local expLoadingBar = sf.createLoadingBar({name = "expLoadingBar", plist = 1, src = "loading_bar.png",<br/>
 -- percent = percent, pos = cc.p(headColorImg:getContentSize().width / 2, -17)})
function sf.createLoadingBar( params )
    local loadingBar = ccui.LoadingBar:create()
    local src = params.src or "loading_bar.png"

    loadingBar:loadTexture(src)

    loadingBar:setPosition(params.pos or cc.p(0, 0))
    loadingBar:setAnchorPoint(params.ap or cc.p(0.5, 0.5))
    loadingBar:setPercent(params.percent or 0)
    loadingBar:setDirection(params.direction or LoadingBarTypeLeft)

    -- function loadingBar:setPercentByAction( percent, time, callback, frameTime )
    --     self:stopAllActions()
    --     time = time or 0
    --     frameTime = frameTime or 0.1
    --     local curPercent = self:getPercent()
    --     if curPercent == percent then return end
    --     if time <= 0 then
    --         self:setPercent(percent)
    --     else
    --         local speed = (percent - curPercent)/ time * frameTime
    --         self:runAction(
    --             CCSequence:createWithTwoActions(
    --                 CCRepeat:create(
    --                     CCSequence:createWithTwoActions(
    --                         CCDelayTime:create(frameTime),
    --                         CCCallFunc:create(
    --                             function (  )
    --                                 curPercent = curPercent + speed
    --                                 if (speed > 0 and curPercent > percent) or (speed < 0 and curPercent < percent) then
    --                                     curPercent = percent
    --                                 end
    --                                 self:setPercent(curPercent)
    --                             end
    --                         )
    --                     ),
    --                     math.ceil(time/frameTime) + 1
    --                 ),
    --                 CCCallFuncN:create(
    --                     function (  )
    --                         if callback then
    --                             callback()
    --                         end
    --                     end
    --                 )
    --             )
    --         )
    --     end
    -- end

    if params.rotate then
        loadingBar:setRotation(params.rotate)
    end

    if params.name then
        loadingBar:setName(params.name)
    end

    if params.tag then
        loadingBar:setTag(params.tag)
    end

    -- 可以设置Scale9
    if params.size then
        loadingBar:setScale9Enabled(true)
        loadingBar:setContentSize(params.size)
    end

    if params.opacity then
        loadingBar:setOpacity(params.opacity)
    end

    if params.parent then
        params.parent:addChild(loadingBar)
    end

    return loadingBar
end


-- 显示提示Tip
function sf.tipInfo( params )

    -- local mParams = {}

    -- if type(params) == "string" or type(params) == "number" then
    --     mParams.text = params
        -- mParams.type = sf.TIP_TYPE_LABEL
    -- else
    --     mParams = params
    -- end

    -- sf.createPop("src/app/pop/tipPop", mParams)
end

-- 创建图片，cc.sprite
function sf.createSprite( src )
    local _s = nil
    if src then
        _s = cc.Sprite:create(src)
    else
        print("创建图片的路径为空！！！")
    end
    return _s
end

-- 去掉黑色背景的图片
function sf.createBlendFuncSprite( src )
    local blf = cc.blendFunc()
    blf.src = GL_DST_COLOR
    blf.dst = GL_ONE

    local sp = sf.createSprite(src)
    sp:setBlendFunc(blf)
    
    return sp
end

function sf.createAttrLabel( params, extraParams )
    -- 主节点
    local baseLayout = ccui.Layout:create()
    local contentLayout = ccui.Layout:create()
    baseLayout:addChild(contentLayout)

    baseLayout.contentLayout = contentLayout -- reg


    local preItem = nil
    local nowItem = nil
    local maxWidth = 0
    local maxHeight = 0

    for i,v in ipairs(params) do
        
        if v.text then
            local label = sf.createLabel( v )
           
            nowItem = label -- reg

        elseif v.image then
            local img = nil

            if v.type then
                v.src = sf.getAttrResPath( v.type, v.id )
                img = sf.createImageView(v)
            elseif v.src then
                img = sf.createImageView(v)
            end

            nowItem = img -- reg

        end

        nowItem:setAnchorPoint(cc.p(0, 0))
        nowItem:setTag(i)

        local offsetX = v.offsetX or 0
        nowItem.offsetX = offsetX -- reg更新使用

        local offsetY = v.offsetY or 0
        nowItem.offsetY = offsetY -- reg更新使用

        if i == 1 then
            nowItem:setPosition(0, 0) -- 第一个值设置offset无用，所有的偏移X都基于前一个值,偏移Y基于第一个值
        else
            nowItem:setPosition(cc.p(preItem:getContentSize().width * preItem:getScale() + preItem:getPositionX() + offsetX, offsetY))
        end

        -- 获得高度（不以offsetY作为执行）
        if nowItem:getContentSize().height * nowItem:getScaleY() > maxHeight then
            maxHeight = nowItem:getContentSize().height * nowItem:getScaleY()
        end


        preItem = nowItem
        contentLayout:addChild(nowItem)

    end

    if extraParams then
        
        if extraParams.name then
            baseLayout:setName(extraParams.name)
        end

        if extraParams.ap then -- 内容做偏移
            baseLayout:setAnchorPoint(extraParams.ap)
        end

        if extraParams.pos then
           baseLayout:setPosition(extraParams.pos)
        end

        if extraParams.zOrder then
            baseLayout:setLocalZOrder(extraParams.zOrder)
        end

        if extraParams.parent then
           extraParams.parent:addChild(baseLayout)
        end

    end

    local maxWidth = preItem:getContentSize().width * preItem:getScale() + preItem:getPositionX()

    contentLayout:setPosition(maxWidth * -baseLayout:getAnchorPoint().x, maxHeight * -baseLayout:getAnchorPoint().y)

    baseLayout.maxWidth = maxWidth -- reg
    baseLayout.maxHeight = maxHeight -- reg

    return baseLayout
end


function sf.updateAttrLabel( layout, params, extraParams )

    -- 主节点
    local baseLayout = layout
    local contentLayout = baseLayout.contentLayout

    local preItem = contentLayout:getChildByTag(1)
    local nowItem = contentLayout:getChildByTag(1)
    local maxWidth = baseLayout.maxWidth
    local maxHeight = baseLayout.maxHeight

    for i,v in ipairs(params) do
        nowItem = contentLayout:getChildByTag(i)

        if v.text then
            nowItem:setString(v.text)

            if v.color then
                nowItem:setColor(v.color)
            end
            if v.outline then
                local outlineSize = 1
                if v.outlineSize then
                    outlineSize = v.outlineSize
                end
                local outlineColor = cc.c4b(106, 74, 46, 255)
                if v.outlineColor then
                    outlineColor = v.outlineColor
                end
                nowItem:enableOutline(outlineColor, outlineSize)
            end

        elseif v.image then

            if v.type then
                v.src = sf.getAttrResPath( v.type, v.id )
                nowItem:loadTexture(v.src)
            elseif v.src then
                nowItem:loadTexture(v.src)
            end

        end

        local offsetX = v.offsetX or nowItem.offsetX
        nowItem.offsetX = offsetX -- reg

        local offsetY = v.offsetY or nowItem.offsetY -- 默认偏移量
        nowItem.offsetY = offsetY -- reg
       
        if i == 1 then
            nowItem:setPosition(0, 0)
        else
            nowItem:setPosition(preItem:getContentSize().width * preItem:getScale() + preItem:getPositionX() + offsetX, offsetY)
        end

        -- 获得高度
        if nowItem:getContentSize().height * nowItem:getScaleY() > maxHeight then
            maxHeight = nowItem:getContentSize().height * nowItem:getScaleY()
        end

        preItem = nowItem

    end

    -- 
    if extraParams then
        
        if extraParams.ap then -- 内容做偏移
            baseLayout:setAnchorPoint(extraParams.ap)
        end

        if extraParams.pos then
           baseLayout:setPosition(extraParams.pos)
        end

    end

    local maxWidth = preItem:getContentSize().width * preItem:getScale() + preItem:getPositionX()

    contentLayout:setPosition(maxWidth * -baseLayout:getAnchorPoint().x, maxHeight * -baseLayout:getAnchorPoint().y)

    baseLayout.maxWidth = maxWidth -- reg
    baseLayout.maxHeight = maxHeight -- reg

end

--[[
    游戏内UI组件
]]
function sf.createHeadIcon( params )
    params.shapeType = params.shapeType or 0
    params.src = "res/Image/rolehead/role_head_0.jpg"

    local layout = sf.createLayout({
            pos = params.pos,
            parent = params.parent,
            scale = params.scale,
        })

    local headIcon = nil
    if params.shapeType == 1 then --1：圆 其它：方
        
        local circleDrawNode = cc.Sprite:create("res/Image/rolehead/head_mask_bg_1.png")
        local clippingNode = cc.ClippingNode:create(circleDrawNode)
        clippingNode:setPosition(0, 0)
        clippingNode:setInverted(false)
        clippingNode:setAlphaThreshold(0.5)
        layout:addChild(clippingNode)

        params.pos = nil
        params.parent = clippingNode
        params.scale = nil
        headIcon = sf.createImageView(params)

        sf.createImageView({
            src = "res/Image/rolehead/head_mask_img.png",
            pos = cc.p(0, 0),
            parent = layout
        })
        layout.headIcon = headIcon
    elseif params.shapeType == 2 then 
        local squareDrawNode = cc.Sprite:create("res/Image/rolehead/head_mask_bg.png")
        local clippingNode = cc.ClippingNode:create(squareDrawNode)
        clippingNode:setPosition(0, 0)
        clippingNode:setInverted(false)
        clippingNode:setAlphaThreshold(0.5)
        layout:addChild(clippingNode)

        params.pos = nil
        params.parent = clippingNode
        params.scale = nil
        headIcon = sf.createImageView(params)

        layout.headIcon = headIcon
    else
        params.parent = layout
        params.pos = cc.p(0, 0)
        headIcon = sf.createImageView(params)
        if params.border then
            -- 名字背景
            sf.createImageView({
                src = "res/Image/rolehead/role_head_box.png",
                pos = cc.p(headIcon:getContentSize().width / 2, headIcon:getContentSize().height / 2),
                parent = headIcon
            })
        end
        layout.headIcon = headIcon
    end

    layout.loadTexture = function(self, img)
        if not tolua.isnull(headIcon) then
            headIcon:loadTexture(img)
        end
    end
    
    sf.updateHeadIcon(headIcon, params)

    return layout
end

-- 更新图标
function sf.updateHeadIcon(headIcon, params)

    if tolua.isnull(headIcon) then
        return
    end

    if type(tonumber(params.image)) == "number" then
        headIcon:loadTexture("res/Image/rolehead/role_head_" .. params.image .. ".jpg")
    elseif type(params.image) == "string" then
        -- 网络图片
        if string.find(params.image, "http") then

            -- MD5作为文件名
            local md5Str = md5.sumhexa(params.image)

            local downloadPath = "tmp/head/" .. md5Str .. ".jpg"

            if cc.FileUtils:getInstance():isFileExist(downloadPath) then
                
                headIcon:loadTexture(downloadPath)
            else

                sf.simpleDownload({
                    url = params.image,
                    path = downloadPath,
                    successCallback = function (  )
                        if not tolua.isnull(headIcon) then
                            headIcon:loadTexture(downloadPath)
                        end
                    end
                    })
            end
        end

    end
    
end

--- 提示框抖动
-- @param node 要抖动的节点
-- @param callback 动作结束后的回调
function sf.elasticInAction(widget, callback, maxScale)
    if widget ~= nil then
        widget:setScale(0.3)
        local scale = 1
        if maxScale then
            scale = maxScale
        end
        local action1 = cc.ScaleTo:create(0.15, scale)
        local action2 = cc.ScaleTo:create(0.1, scale - 0.1)
        local action3 = cc.ScaleTo:create(0.1, scale)

        local actionArray = {action1, action2, action3}

        if(callback ~= nil) then
            table.insert(actionArray, cc.CallFunc:create(callback))
        end

        widget:runAction(cc.Sequence:create(actionArray))
    end
end

local maskInstance = nil
--- 显示一个全屏遮罩，吞噬触摸
-- @param delayTime 持续时间
-- @param opacity 透明度(100)
-- @param rect 显示区域
-- @see sf.hideMask
-- @usage sf.showMask(0.5, 180, CCRect(0, 0, 100, 100))
function sf.showMask(delayTime, opacity)

    -- 持续时间
    -- local delayTime = delayTime or 0
    -- 透明度
    local opacity = opacity or 0

    local touchLayer = sf.getTouchLayer()

    local maskWidget = ccui.Widget:create()
    maskWidget:setLocalZOrder(sf.Z_ORDER_MASK)
    touchLayer:addChild(maskWidget)

    local maskLayout = sf.createLayout({mask = true, opacity = opacity, size = cc.size(sf.width, sf.height)})
    maskLayout:setTouchEnabled(true)
    maskWidget:addChild(maskLayout)


    if delayTime then -- 这个会自动清除
        local action = {}
        action[#action+1] = cc.DelayTime:create(delayTime)
        action[#action+1] = cc.CallFunc:create(function ()
            maskWidget:removeFromParent(true)
        end)
        maskWidget:runAction(cc.Sequence:create(action))
    else -- 这个是单例
        maskInstance = maskWidget -- reg
    end

end

--- 关闭全屏遮罩
-- @see sf.showMask
function sf.hideMask()
    if maskInstance and tolua.isnull(maskInstance) == false then
        maskInstance:removeFromParent(true)
    end

    maskInstance = nil

end

-- 置灰
function sf.setGray(node, gray)
    if not node then
        return
    end
    if gray ~= nil and gray == false then
        node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgramName("ShaderPositionTextureColor_noMVP"))
    else
        sf.setShader(node,"res/shader/gray.vsh","res/shader/gray.fsh")
    end
end

function sf.setShader(node,vsh,fsh)
    local glProgram = cc.GLProgramCache:getInstance():getGLProgram(vsh)
    if glProgram == nil then
        local pProgram = cc.GLProgram:create(vsh,fsh)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION,cc.VERTEX_ATTRIB_POSITION)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR,cc.VERTEX_ATTRIB_COLOR)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD,cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
        pProgram:link()
        pProgram:updateUniforms()
        cc.GLProgramCache:getInstance():addGLProgram(pProgram,vsh)
        glProgram = cc.GLProgramCache:getInstance():getGLProgram(vsh)
        -- print("添加shader:["..vsh.."]")
    else
        -- print("找到shader:["..vsh.."]")
    end
    node:setGLProgram(glProgram)
end


--[[ -- 另一种方法
    local expression = display.createArmature("NewAnimation")
    expression:setScale(1.0)
    expression:setPosition(cc.p(0, -50))
    parent:addChild(expression, 10)
    expression:getAnimation():play(tostring(magicId))
    expression:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementID)
        if tolua.isnull(expression) then return end     
        if 1 == tonumber(movementType) then
            expression:removeFromParent()
        end
    end)
]]
--[[
@ fileName          = --文件名，不包括父目录以及后缀名
@ actName           = --需要播放的动作名,如果此参数为nil，则代表只创建骨骼动画
@ loop              = --是否循环，默认不循环
@ parentPath        = --父目录
@ suffix            = --后缀
@ completeCallback  = --动作完成后的回调事件
@ eventCallback     = --帧事件
@ moveCallback      = --
@ autoRemove        = ----动作complete后是否自动删除
]]
function sf.createArmature(params)
    local fileName          = tostring(params.fileName)--[[文件名，不包括父目录以及后缀名]]
    local actName           = params.actName
    local loop              = params.loop
    local parentPath        = params.parentPath--[[父目录]]
    local suffix            = params.suffix--[[后缀]]
    local completeCallback  = params.completeCallback--[[动作完成后的回调事件]]
    local eventCallback     = params.eventCallback
    local moveCallback      = params.moveCallback
    local autoRemove        = params.autoRemove--[[--动作complete后是否自动删除]]
    local async             = params.async
    local asyncCallback     = params.asyncCallback
    local autoRelease       = params.autoRelease
    if autoRemove == nil then autoRemove = false end
    if parentPath == nil then parentPath = "res/animation/" end
    if suffix     == nil then suffix = ".csb" end
    local resFile           = parentPath..tostring(fileName)..suffix
    print("resFile="..resFile..",fileName="..tostring(fileName))
    local armatureDataManager = ccs.ArmatureDataManager:getInstance()
    local armature          = nil
    local _haveAdd = false
    if cc.FileUtils:getInstance():isFileExist(resFile) == true then
        --[[目前只做简单的异步加载]]
        if async == true then
            armature = ccs.Armature:create()
            --[[如果异步加载失败，就删除掉该记录]]
            armatureDataManager:addArmatureFileInfoAsync(resFile, function(num) 
                if armatureDataManager:getAnimationData(fileName) and armatureDataManager:getArmatureData(fileName) then
                    -- print("异步加载成功："..resFile..",fileName="..fileName)
                else
                    print("异步加载失败："..resFile..",fileName="..fileName)
                end
                local _armature_ = nil
                if not tolua.isnull(armature) then 
                    armature:init(fileName) 
                    _armature_ = armature
                end
                if asyncCallback then asyncCallback(_armature_ , fileName , num) end
            end)
        else
            armatureDataManager:addArmatureFileInfo(resFile)
            armature = ccs.Armature:create(fileName)
            if armature and actName and string.len(tostring(actName)) > 0 then
                actName             = tostring(actName)
                local animation     = armature:getAnimation()
                --[[--如果为空，则默认不循环]]
                if loop == nil or tostring(loop) == "false" then
                    loop = 0
                elseif tostring(loop) == "true" or tonumber(loop) > 0 then
                    loop = 1
                end
                animation:play(actName,-1,loop)
                
                if moveCallback == nil then
                    moveCallback = function (armatureBack,movementType,movementID)
                        if movementType == ccs.MovementEventType.complete then
                            if completeCallback then
                                completeCallback()
                            end
                            if autoRemove == true and loop == 0 then 
                                xpcall(function() 
                                    if not tolua.isnull(armature) then
                                        armature:removeFromParent()
                                    end
                                end, function ()
                                    print("armature已被删除")
                                end)
                            end
                        end
                    end
                end
                animation:setMovementEventCallFunc(moveCallback)
                if eventCallback then
                    animation:setFrameEventCallFunc(eventCallback)
                end
            end
        end
    else
        print("************************************文件"..resFile.."不存在")
    end
    -- print("*************************"..tostring(socket.gettime() - time)..",readFileTime="..tostring(readFileTime)..",creatTime="..tostring(creatTime)..",resFile="..resFile)
    return armature
end






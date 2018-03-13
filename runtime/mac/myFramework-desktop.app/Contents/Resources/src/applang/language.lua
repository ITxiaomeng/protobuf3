--[[
    注意：
    1.通用型语言，全部放到langCommon；语言尽可能写得通用点。
    2.每个模块的语言，必须带上模块前缀，命名规范，清晰易懂。
]]

local langConfig = {}

-- 语言
local devLanguage = cc.UserDefault:getInstance():getStringForKey("devLanguage")

if devLanguage == nil or devLanguage == "" then

    sf.language = "cn"

else
    sf.language = devLanguage
end


function sf.loadLangConfig(  )

    print(sf.language, "sf.language")


    langConfig = sf.require("src/applang/" .. sf.language)
end

sf.loadLangConfig(  )

-- dump(langConfig)

function sf.lang( ... )
    local arg = { ... }

    if #arg == 0 then
        return ""
    end

    local langKey = arg[1]
    local langVal = ""

    langVal = langConfig[langKey] or arg[2]


    for i = 3, #arg do
        langVal = string.gsub(langVal, "{" .. (i - 2) .. "}", arg[i])
    end

    return langVal
end

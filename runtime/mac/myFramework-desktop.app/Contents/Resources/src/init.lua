require("src/BaseConfig")
require("src/component/LayerManager")
require("src/common")
require("src/commonHelper")
require("src/component/opConfig")
SocketTCP = require("src/cocos/framework/net/SocketTCP")
require("src/network/init")
-- require("src/component/GameManager"):start()   -- TCP连接,应该在进入主场景的时候去执行start()

-- PacketBuffer = require("src/component/PacketBuffer")  -- 应该是接受数据的协议，目前没有弄
PopBase = require("src/app/layers/base/PopBase")
SceneBase = require("src/app/layers/base/SceneBase")
require 'FairyGUI'
require 'module/mainView/MainView'

xutil = require 'xlua.util'

print('lua启动成功')

-- local view = MainPanel.New();
-- view:Show();

GRoot.inst:SetContentScaleFactor(720, 1440)
UIPackage.AddPackage('FairyGUI/Common')
local mainView = MainView.New()
mainView:Show()
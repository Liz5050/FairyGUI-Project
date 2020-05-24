require 'module/base/BaseGUIView'
require 'module/mainView/ImageTestView'
require 'UI/List'
require 'manager/UIExtensionManager'

local view = fgui.window_class()
local TestItem
function view:ctor()
    print("MainView ctor")
    UIPackage.AddPackage('FairyGUI/Main')
    UIExtensionManager.register(PackageName.Main)
    --fgui.add_timer(2,1,function()
    --    --UIExtensionManager.register(PackageName.Main)
    --
    --    view.list = List(self.contentPane:GetChild("list_test"))
    --    view.list.SetData({1,2,3,4})
    --end)
end

function view:OnInit()
    self.contentPane = UIPackage.CreateObject('Main', 'Main')

    local listData = {}
    view.btnTest = self.contentPane:GetChild("btnTest")
    view.btnTest.onClick:Add(function()
        print("按钮点击")
        view.list = List(self.contentPane:GetChild("list_test"),TestItem)
        for i = 1,1000 do
            table.insert(listData,i)
        end
        --view.list.SetData(listData)
        view.list.SetVirtual(listData)
        print("列表滚动位置",view.list.list.scrollPane.posY)
        view.list.list:ScrollToView(100,true)
        print("列表滚动位置",view.list.list.scrollPane.posY)
    end)

    --view.imgTest = ImageTestView.Extend(self.contentPane:GetChild("n61"))

    view.btnTop = self.contentPane:GetChild("btnTop")
    view.btnBottom = self.contentPane:GetChild("btnBottom")
    view.btnScrollEffect = self.contentPane:GetChild("btnScrollEffect")

    view.btnTop.onClick:Add(function()
        view.list.list:ScrollToView(0,view.btnScrollEffect.selected)
    end)

    view.btnBottom.onClick:Add(function()
        view.list.list:ScrollToView(#listData - 1,view.btnScrollEffect.selected)
    end)
end

function view:OnShown()
end

function view:OnHide()
end

MainView = MainView or view

TestItem = function()
    local private = {}
    local public = {}

    public.Init = function(itemGo)
        private.itemGo = itemGo
        private.txtTitle = itemGo:GetChild("txtTitle")
    end

    public.SetData = function(data,index,len)
        private.data = data
        private.index = index
        private.len = len
        private.txtTitle.text = "文本"..data
    end

    return public
end
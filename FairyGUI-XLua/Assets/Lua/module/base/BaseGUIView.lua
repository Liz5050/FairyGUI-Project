BaseGUIView = {}
local view = {}
function BaseGUIView.window_class()
    local o = {}
    
    local base = fgui.window_class(view)
    setmetatable(o, base)

    o.__index = o
    o.base = base

    o.New = function(...)
        local t = {}
        setmetatable(t, o)

        local ins = FairyGUI.LuaWindow()
		-- tolua.setpeer(ins, t)
		xutil.state(ins, t)
        ins:ConnectLua(t)
        t.EventDelegates = {}
        if t.ctor then
            t.ctor(ins,...)
        end

        return ins
    end

    return o
end

function view:ctor()
    print("base ctor")
end

function view:OnInit()
    
end

function view:OnShow()
end

function view:OnHide()
end
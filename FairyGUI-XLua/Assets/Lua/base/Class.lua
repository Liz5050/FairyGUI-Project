
local type, next, setmetatable, getmetatable, rawget = type, next, setmetatable, getmetatable, rawget

function deepcopy(orig)
    local copy

    if type(orig) == "table" then
        copy = {}

        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end

        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

-- 如果有重写父类的方法，则遍历父类方法并将同名方法保存的tb.Super(class_type.vtbl.Super)表中
function shiftToSuper(tb, k, v, class_type)
    local tbv = tb[k]

    if tbv then
        local super = class_type.super

        while super do
            if rawget(super.selfFun, k) then
                if not tb.Super then
                    tb.Super = {}
                end

                if not tb.Super[super.className] then
                    tb.Super[super.className] = {}
                end

                tb.Super[super.className][k] = super.selfFun[k]
            end

            super = super.super
        end

        rawset(tb, k, v)

        return
    else
        rawset(tb, k, v)
        return
    end
end

-- function is_a(obj, class)
--     if type(obj) ~= 'table' then return false end
--     if obj == class then return true end

--     local mt = getmetatable(obj)
--     while mt do
--         if mt.__class_type == class then return true end
--         mt = mt.super
--     end

--     return false
-- end

local function forbid_new(t, k, v)
    error("attempt to newindex a not exist value:"..k)
end

--[[
初始化对象及其所有父类部分(class.new中调用)
--]]
function create(c, obj, argTableInit)
    if c.super then
        create(c.super, obj, argTableInit)
    end
    if c.init then
        c.init(obj, argTableInit)
    end
end

--[[
类型模板
--]]
function class(super, className)
    local class_type={}

    class_type.init = false
    class_type.className = className

    if "string" == type(super) then
        class_type.className = super
    elseif "table" == type(super) then
        class_type.super=super
    end

    class_type.selfFun = {}     -- 保存类型的自身方法和重写的父类方法。元表为父类class_type.selfFun和重写的父类方法

    -- 访问class_type.selfFun表的抽象层
    class_type.mt =
    {
        __index = class_type.selfFun
    }

    -- 创建一个新对象
    class_type.new = function(argTableInit)
        local obj = {}

        local mt = class_type.mt

        setmetatable(obj,mt)

        mt.__newindex = nil

        obj.__className = class_type.className

        -- 初始化对象及其所有父类部分
        create(class_type, obj, argTableInit)

        mt.__newindex = forbid_new

        return obj
    end

    -- local vtbl = class_type.vtbl
    local vtbl = class_type.selfFun

    function vtbl:clone()
        return deepcopy(self)
    end

    -- 用于访问重写的父类方法
    function vtbl:super(className, method, ...)
        return self.Super[className][method](self, ...)     -- Super字段在shiftToSuper中创建的
    end

    -- 复制父类的重写方法和将父类的class_type.super.selfFun作为元表
    if class_type.super then
        -- for k,v in pairs(class_type.super.vtbl) do
        for k,v in pairs(class_type.super.selfFun) do
            if k == "Super" then
                vtbl[k] = deepcopy(v)
                -- else
                --     vtbl[k] = v
            end
        end
        setmetatable(class_type.selfFun, { __index = class_type.super.selfFun })
    end

    setmetatable(class_type, {__newindex=
                              function(t, k, v)
                                  if "init" == k then     -- 构建类型(table赋值)时，如果存在init字段，则将其作为初始化方法
                                      class_type.init = v
                                  else
                                      shiftToSuper(class_type.selfFun, k, v, class_type)
                                  end
                              end
    })

    return class_type
end
